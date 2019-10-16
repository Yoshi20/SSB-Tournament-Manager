class TournamentsController < ApplicationController
  before_action :set_tournament, except: [:index, :new, :create]
  before_action :check_if_admin, except: [:index, :show, :add_player, :remove_player, :location]
  before_action { @section = 'tournaments' }

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.active_2019.upcoming.order(date: :asc).includes(:players).paginate(page: params[:page], per_page: Tournament::MAX_PAST_TOURNAMENTS_PER_PAGE)
    @ongoing_tournaments = Tournament.active_2019.ongoing.order(date: :asc).includes(:players).paginate(page: params[:page], per_page: Tournament::MAX_PAST_TOURNAMENTS_PER_PAGE)
    @past_tournaments = Tournament.active_2019.past.order(date: :desc).includes(:players).paginate(page: params[:page], per_page: Tournament::MAX_PAST_TOURNAMENTS_PER_PAGE)
    if current_user.present? and current_user.super_admin?
      @inactive_tournaments = Tournament.where(active: false).order(date: :desc).paginate(page: params[:page], per_page: Tournament::MAX_PAST_TOURNAMENTS_PER_PAGE)
    end
    # handle search parameter
    if params[:search].present?
      @tournaments = @tournaments.search(params[:search])
      @past_tournaments = @past_tournaments.search(params[:search])
      if @tournaments.empty? and @past_tournaments.empty?
        flash.now[:alert] = t('flash.alert.search_tournaments')
      end
      @inactive_tournaments = @inactive_tournaments.search(params[:search]) if @inactive_tournaments.present?
    end
    if params[:filter].present? and params[:filter] != 'all'
      if helpers.tournament_cities.include?(params[:filter].capitalize)
        city = params[:filter].capitalize
        @tournaments = @tournaments.where(city: city).or(
          @tournaments.from_city(city)
        )
        @past_tournaments = @past_tournaments.where(city: city).or(
          @past_tournaments.from_city(city)
        )
      else  # 'weekly', 'internal' or 'external'
        @tournaments = @tournaments.where(subtype: params[:filter])
        @past_tournaments = @past_tournaments.where(subtype: params[:filter])
      end
    end
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    players_per_game_station = (@tournament.total_seats.to_f/@tournament.total_needed_game_stations).ceil() if @tournament.total_needed_game_stations.to_i > 0
    @min_needed_game_stations = (@tournament.min_needed_registrations.to_f/players_per_game_station).ceil() if players_per_game_station.to_i > 0
    if @tournament.players.count < @tournament.min_needed_registrations.to_i
      @currently_needed_game_stations = @min_needed_game_stations - @tournament.game_stations_count if @min_needed_game_stations.present?
    else
      @currently_needed_game_stations = (@tournament.players.count.to_f/players_per_game_station).ceil() - @tournament.game_stations_count if players_per_game_station.to_i > 0
    end
    @registration = @tournament.registrations.where(player_id: current_user.player.id).first if current_user.present?
  end

  # GET /tournaments/new
  def new
    @tournament = Tournament.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments
  # POST /tournaments.json
  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.ranking_string = ''
    # handle the different subtypes
    if @tournament.subtype.nil? or @tournament.subtype == 'internal'
      respond_to do |format|
        if check_registration_deadline_is_less_than_date(tournament_params) && @tournament.save
          if params[:send_mails]
            Player.all.each do |p|
              if p.user.wants_major_email
                TournamentMailer.with(tournament: @tournament, user: p.user).new_tournament_email.deliver_later
              end
            end
          end
          format.html { redirect_to @tournament, notice: t('flash.notice.create_internal_tournament') }
          format.json { render :show, status: :created, location: @tournament }
        else
          format.html { render :new }
          format.json { render json: @tournament.errors, status: :unprocessable_entity }
        end
      end
    elsif @tournament.subtype == 'external'
      respond_to do |format|
        if @tournament.save
          if params[:send_mails]
            Player.all.each do |p|
              if p.user.wants_major_email
                TournamentMailer.with(tournament: @tournament, user: p.user).new_external_tournament_email.deliver_later
              end
            end
          end
          format.html { redirect_to tournaments_path, notice: t('flash.notice.create_external_tournament') }
          format.json { render :show, status: :created, location: @tournament }
        else
          format.html { render :new }
          format.json { render json: @tournament.errors, status: :unprocessable_entity }
        end
      end
    elsif @tournament.subtype == 'weekly'
      @tournament.name = generate_weekly_name(@tournament.city, @tournament.date)
      respond_to do |format|
        if check_registration_deadline_is_less_than_date(tournament_params) && @tournament.save
          if params[:send_mails]
            Player.all.each do |p|
              if p.user.wants_weekly_email
                TournamentMailer.with(tournament: @tournament, user: p.user).new_weekly_tournament_email.deliver_later
              end
            end
          end
          # saving the first weekly succeeded -> create x more until end_date is reached
          last_weekly = @tournament
          while last_weekly.date + 7.days <= @tournament.end_date do
            next_weekly = last_weekly.dup()
            next_weekly.date = last_weekly.date + 7.days
            next_weekly.registration_deadline = last_weekly.registration_deadline + 7.days
            next_weekly.name = generate_weekly_name(next_weekly.city, next_weekly.date)
            if next_weekly.save
              last_weekly = next_weekly
            else
              format.html { render :new }
              format.json { render json: next_weekly.errors, status: :unprocessable_entity }
              return
            end
          end
          format.html { redirect_to @tournament, notice: t('flash.notice.create_weekly_tournament') }
          format.json { render :show, status: :created, location: @tournament }
        else
          format.html { render :new }
          format.json { render json: @tournament.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    # update tournament
    if @tournament.subtype.nil? or @tournament.subtype == 'internal' or  @tournament.subtype == 'weekly'
      respond_to do |format|
        oldName = @tournament.name
        oldDate = @tournament.date
        oldcity = @tournament.city
        if check_registration_deadline_is_less_than_date(tournament_params) && @tournament.update(tournament_params)
          # also update weekly name if city was edited
          if @tournament.subtype == 'weekly' && @tournament.city != oldcity
            @tournament.name = generate_weekly_name(@tournament.city, @tournament.date)
            unless @tournament.save
              format.html { render :edit }
              format.json { render json: t.errors, status: :unprocessable_entity }
              return
            end
          end

          # check the 'all' parameter and update all upcoming tournaments of this type if it's true
          if @tournament.subtype == 'weekly' and params[:commit].include?('all')
            last_weekly = @tournament
            edited_tournament_params = tournament_params
            old_name_without_kw = oldName[0.. -10].strip  # 'SSBU Weekly xxx KWyy 20zz' -> 'SSBU Weekly xxx'
            Tournament.where('date >= ?', oldDate + 7.days).where("name ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(old_name_without_kw)}%").order(:date).each do |t|
              edited_tournament_params[:name] = generate_weekly_name(last_weekly.city, last_weekly.date + 7.days)
              if t.update(edited_tournament_params)
                t.date = last_weekly.date + 7.days
                t.registration_deadline = last_weekly.registration_deadline + 7.days
                if t.save
                  last_weekly = t
                else
                  format.html { render :edit }
                  format.json { render json: t.errors, status: :unprocessable_entity }
                  return
                end
              else
                format.html { render :edit }
                format.json { render json: t.errors, status: :unprocessable_entity }
                return
              end
            end
            format.html { redirect_to @tournament, notice: t('flash.notice.update_weekly_tournament') }
          else
            format.html { redirect_to @tournament, notice: t('flash.notice.update_internal_tournament') }
          end
          format.json { render :show, status: :ok, location: @tournament }
        else
          format.html { render :edit }
          format.json { render json: @tournament.errors, status: :unprocessable_entity }
        end
      end
    elsif @tournament.subtype == 'external'
      respond_to do |format|
        if check_registration_deadline_is_less_than_date(tournament_params) && @tournament.update(tournament_params)
          format.html { redirect_to tournaments_path, notice: t('flash.notice.update_external_tournament') }
          format.json { render :show, status: :ok, location: @tournament }
        else
          format.html { render :edit }
          format.json { render json: @tournament.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    if @tournament.active == false
      if @tournament.destroy
        respond_to do |format|
          format.html { redirect_to tournaments_url, notice: t('flash.notice.delete_tournament') }
          format.json { head :no_content }
        end
      else
        redirect_to tournaments_url, alert: t('flash.alert.delete_tournament')
      end
    else
      if @tournament.subtype == 'weekly' and params[:all]
        # deactivate all upcoming weeklies of this type
        name_without_kw = @tournament.name[0.. -10].strip  # 'SSBU Weekly xxx KWyy 20zz' -> 'SSBU Weekly xxx'
        Tournament.where('date >= ?', @tournament.date).where(location: @tournament.location).where(host_username: @tournament.host_username).each do |tt|
          if tt.name[0.. -10].strip == name_without_kw
            tt.update(active: false)
          end
        end
      end
      if @tournament.update(active: false)
        respond_to do |format|
          format.html { redirect_to tournaments_url, notice: t('flash.notice.deactivate_tournament') }
          format.json { head :no_content }
        end
      else
        redirect_to tournaments_url, alert: t('flash.alert.deactivate_tournament')
      end
    end
  end

  # POST /tournaments/add_player/1
  def add_player
    if params[:gamer_tag].present?
      player_to_add = Player.find_by(gamer_tag: params[:gamer_tag])
    else
      player_to_add = current_user.player
    end

    if player_to_add.nil?
      redirect_to @tournament, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.player_not_found')}"
      return;
    end

    if @tournament.registration_deadline and Time.now > @tournament.registration_deadline and !params[:gamer_tag].present?
      redirect_to @tournament, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.deadline_exceeded')}"
      return;
    end

    if @tournament.players.include?(player_to_add)
      redirect_to @tournament, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.player_already_added')}"
      return;
    end

    if @tournament.total_seats.present? and @tournament.players.count < @tournament.total_seats
      # tournament is not full yet -> add the player to the tournament
      @tournament.players << player_to_add
      # re-seed players
      tournament_registrations = @tournament.registrations
      seeded_participants_id_array = helpers.seed_players(@tournament.players).map { |p| p.id }
      seeded_participants_id_array.each_with_index do |id, i|
        tournament_registrations.find_by(player_id: id).set_list_position(i+1)
      end
      # remove the player from the waiting list
      if @tournament.waiting_list.include?(player_to_add.gamer_tag)
        @tournament.waiting_list.delete(player_to_add.gamer_tag)
        if @tournament.save
          redirect_to @tournament, notice: "#{t('flash.notice.add_player')} #{t('flash.notice.removed_from_wating_list')}"
        else
          redirect_to @tournament, alert: "#{t('flash.notice.add_player')} #{t('flash.alert.not_removed_from_wating_list')}"
        end
      else
        redirect_to @tournament, notice: t('flash.notice.add_player')
      end
    else
      # tournament is full
      if params[:waiting_list] == 'true' or (params[:gamer_tag].present? and !@tournament.players.include?(player_to_add))
        @tournament.waiting_list.push(player_to_add.gamer_tag)
        if @tournament.save
          redirect_to @tournament, notice: t('flash.notice.add_player_to_waiting_list')
        else
          redirect_to @tournament, alert: t('flash.alert.add_player_to_waiting_list')
        end
      else
        redirect_to @tournament, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.tournament_full')}"
      end
    end
  end

  # POST /tournaments/remove_player/1
  def remove_player
    if params[:gamer_tag].present?
      player_to_remove = Player.find_by(gamer_tag: params[:gamer_tag])
    else
      player_to_remove = current_user.player
    end

    if player_to_remove.nil?
      redirect_to @tournament, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.player_not_found')}"
      return;
    end

    if @tournament.registration_deadline and Time.now > @tournament.registration_deadline and !params[:gamer_tag].present?
      redirect_to @tournament, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.deadline_exceeded')}"
      return;
    end

    if !@tournament.players.include?(player_to_remove)
      if @tournament.waiting_list.include?(player_to_remove.gamer_tag)
        @tournament.waiting_list.delete(player_to_remove.gamer_tag)
        if @tournament.save
          redirect_to @tournament, notice: t('flash.notice.remove_player_from_waiting_list')
        else
          redirect_to @tournament, alert: t('flash.alert.remove_player_from_waiting_list')
        end
      else
        redirect_to @tournament, alert: "#{t('flash.alert.remove_player_failed')} -> #{t('flash.alert.player_not_in_tournament')}"
      end
      return;
    end

    # remove the player from the tournament
    @tournament.players.delete(Player.find(player_to_remove.id))

    # check if a player in the waiting list needs to be registered
    if @tournament.waiting_list.length > 0
      gamer_tag_to_add = @tournament.waiting_list.shift # shift is the same as pop_first
      player_to_add = Player.find_by(gamer_tag: gamer_tag_to_add)
      @tournament.players << player_to_add
      TournamentMailer.with(tournament: @tournament, user: player_to_add.user).waiting_player_upgraded_email.deliver_later
      if @tournament.save
        redirect_to @tournament, notice: "#{t('flash.notice.remove_player')} #{t('flash.notice.first_waiting_player')}"
      else
        redirect_to @tournament, alert: "#{t('flash.notice.remove_player')} #{t('flash.alert.first_waiting_player')}"
      end
    else
      redirect_to @tournament, notice: t('flash.notice.remove_player')
    end
  end

  # POST /tournaments/setup/1'
  def setup
    if @tournament.setup or @tournament.started or @tournament.finished
      redirect_to @tournament, alert: t('flash.alert.tournament_status_error')
    else
      # min_needed_game_stations_count = helpers.min_needed_game_stations_per_tournament(@tournament.players.count)
      # current_game_stations_count = @tournament.game_stations_count
      if false # current_game_stations_count < min_needed_game_stations_count
        delta_game_stations = min_needed_game_stations_count - current_game_stations_count
        redirect_to @tournament, alert: "At least #{delta_game_stations} more game #{delta_game_stations > 1 ? 'stations are' : 'station is'} needed to setup the tournament."
      else
        if set_challonge_username_and_api_key()

          # setup a challonge tournament
          ct = Challonge::Tournament.new
          ct.name = @tournament.name #'SSBU Bern KW1' or 'PK Bern #1'
          ct.url = helpers.valid_challonge_url(@tournament.name) #'ssbu_bern_kw1' or 'pk_bern_1'
          ct.tournament_type = 'double elimination'
          ct.group_stages_enabled = @tournament.has_pools?
          ct.game_name = 'Super Smash Bros. Ultimate'
          ct.description = helpers.valid_challonge_description(@tournament.description)
          ActiveRecord::Base.transaction do
            if ct.save! == false
              raise ct.errors.full_messages.inspect
            end
          rescue => error
            redirect_to @tournament, alert: error
            return
          end

          # get seeded players
          seeded_participants_array = []
          all_registrations = @tournament.registrations
          if all_registrations.where(position: nil).any?
            # use seed_points if a position is nil
            seeded_participants_array = helpers.seed_players(@tournament.players).map { |p| p.gamer_tag }
          else
            seeded_participants_array = all_registrations.order(:position).map { |r| r.player.gamer_tag }
          end

          # change the order if there are pools
          if @tournament.has_pools?
            num_of_pools = @tournament.number_of_pools
            players_per_pool = (seeded_participants_array.size.to_f/num_of_pools).round
            pools_hash = Hash.new
            num_of_pools.times do |n|
              pools_hash[n] = Array.new
            end
            i = 0
            (players_per_pool.to_f/2).round.times do
              num_of_pools.times do |n|
                pools_hash[n%num_of_pools] << seeded_participants_array[i]
                i += 1
              end
              num_of_pools.times do |n|
                pools_hash[(num_of_pools-1-n)%num_of_pools] << seeded_participants_array[i]
                i += 1
              end
            end
            seeded_participants_array = []
            num_of_pools.times do |n|
              seeded_participants_array += pools_hash[n]
              if seeded_participants_array.include?(nil) && n != (num_of_pools-1)
                seeded_participants_array.pop # remove the nil at the end
                seeded_participants_array << pools_hash[(num_of_pools-1)].pop # add the last player
              end
            end
          end

          # add the participants to the challonge tournament
          seeded_participants_array.each do |p|
            Challonge::Participant.create(:name => p, :tournament => ct)
          end

          @tournament.setup = true
          @tournament.challonge_tournament_id = ct.id
          if @tournament.save
            if @tournament.has_pools?
              redirect_to @tournament, notice: "#{t('flash.notice.tournament_set_up')}. #{t('flash.notice.two_stage_tournament')}"
            else
              redirect_to @tournament, notice: "#{t('flash.notice.tournament_set_up')}. #{t('flash.notice.check_out_challonge')}"
            end
          else
            redirect_to @tournament, alert: t('flash.alert.tournament_set_up')
          end
        else
          redirect_to @tournament, alert: "#{t('flash.alert.tournament_set_up')}. #{t('flash.alet.challonge_data_missing', link: view_context.link_to(t('flash.alert.here'), edit_user_registration_path, target: '_blank')).html_safe}"
        end
      end
    end
  end

  # POST /tournaments/start/1
  def start
    if !@tournament.setup
      redirect_to @tournament, alert: t('flash.alert.not_set_up_yet')
    elsif @tournament.started or @tournament.finished
      redirect_to @tournament, alert: t('flash.alert.already_started')
    else
      if set_challonge_username_and_api_key()

        # get the correct challonge tournament
        ct = Challonge::Tournament.find(@tournament.challonge_tournament_id)

        ct.start!
        @tournament.started = true
        if @tournament.save
          redirect_to @tournament, notice: t('flash.notice.tournament_started')
        else
          redirect_to @tournament, alert: t('flash.alert.tournament_started')
        end
      else
        redirect_to @tournament, alert: "#{t('flash.alert.tournament_started')}. #{t('flash.alet.challonge_data_missing', link: view_context.link_to(t('flash.alert.here'), edit_user_registration_path, target: '_blank')).html_safe}"
      end
    end
  end

  # POST /tournaments/finish/1
  def finish
    if !@tournament.setup or !@tournament.started
      redirect_to @tournament, alert: t('flash.alert.not_set_up_or_started_yet')
    elsif @tournament.finished
      redirect_to @tournament, alert: t('flash.alert.tournament_finished')
    else
      if set_challonge_username_and_api_key()

        # get the correct challonge tournament
        ct = Challonge::Tournament.find(@tournament.challonge_tournament_id)

        if ct.state == 'complete'
          # get participants and matches (to reduce the request to challonge.com)
          ctps = ct.participants
          ctms = ct.matches

          # updated the participated players and create the matches and results if no exception arises
          ActiveRecord::Base.transaction do
            # create matches
            ctms.each do |ctm|
              match = Match.new
              match.challonge_match_id = ctm.id
              match.tournament_id = @tournament.id
              ctps.each do |ctp|
                gamer_tag = ctp.display_name.gsub("(invitation pending)", "").strip
                if ctp.id == ctm.player1_id
                  player = Player.find_by(gamer_tag: gamer_tag)
                  raise ("#{ctp.display_name} not found in this tournament!").inspect if player.nil?
                  match.player1_id = player.id
                elsif ctp.id == ctm.player2_id
                  player = Player.find_by(gamer_tag: gamer_tag)
                  raise ("#{ctp.display_name} not found in this tournament!").inspect if player.nil?
                  match.player2_id = player.id
                end
              end
              scores = ctm.scores_csv.split('-')
              match.player1_score = scores[0]
              match.player2_score = scores[1]
              match.save! # raise an exception when match.save failed
            end

            # create results and update players
            ctps.each do |ctp|
              gamer_tag = ctp.display_name.gsub("(invitation pending)", "").strip
              player = Player.find_by(gamer_tag: gamer_tag)
              raise ("#{ctp.display_name} not found in this tournament!").inspect if player.nil?
              result = Result.new
              result.player = player
              result.tournament = @tournament
              result.city = @tournament.city
              result.rank = ctp.final_rank
              result.points = helpers.points_repartition_table(ctp.final_rank)
              player.points += result.points
              player.participations += 1
              if ctp.final_rank.present? and (player.best_rank == 0 or ctp.final_rank < player.best_rank) then player.best_rank = ctp.final_rank end
              result.wins = 0
              result.losses = 0
              ctms.each do |ctm|
                scores = ctm.scores_csv.split('-')
                if ctm.player1_id == ctp.id
                  result.wins += scores[0].to_i
                  result.losses += scores[1].to_i
                elsif ctm.player2_id == ctp.id
                  result.wins += scores[1].to_i
                  result.losses += scores[0].to_i
                end
              end
              player.wins += result.wins
              player.losses += result.losses
              if @tournament.subtype == 'internal'
                result.major_name = @tournament.name
              end
              result.save! # raise an exception when result.save failed
              player.save! # raise an exception when player.save failed

              player.update_tournament_experience

              # updated raking_string on the tournament
              ranking_string = "#{ctp.final_rank},#{gamer_tag};"
              @tournament.ranking_string += ranking_string
            end
          end
          # rescue ActiveRecord::RecordInvalid
          #   puts "Something went wrong while updating the players!"
          # end

          @tournament.finished = true
          @tournament.save
          redirect_to @tournament, notice: t('flash.notice.tournament_finished')
        else
          if ct.started_at.nil? then @tournament.update(started: false) end # this happens when a ct was reset
          link = "https://challonge.com/#{ct.url}"
          redirect_to @tournament, alert: t('flash.alert.tournament_not_finished', link: view_context.link_to(link, link, target: '_blank')).html_safe
        end
      else
        redirect_to @tournament, alert: "#{t('flash.alert.tournament_cannot_finish')}. #{t('flash.alet.challonge_data_missing', link: view_context.link_to(t('flash.alert.here'), edit_user_registration_path, target: '_blank')).html_safe}"
      end
    end
  end

  # POST /tournaments/cancel/1
  def cancel
    # send each player an email if the tournament was cancelled
    @tournament.players.each do |p|
      TournamentMailer.with(tournament: @tournament, user: p.user).tournament_cancelled_email.deliver_later
    end
    @tournament.update(tournament_params)
    redirect_to @tournament, notice: t('flash.notice.tournament_cancelled')
  end

  # GET /tournaments/location/1
  # GET /tournaments/location/1.json
  def location

  end

  # PATCH /tournaments/sort_players/1
  def sort_players
    params[:player].each_with_index do |id, i|
      @tournament.registrations.find_by(player_id: id).update(position: i+1)
    end
    head :ok
  end

  # PATCH /tournaments/seed_players/1
  def seed_players
    tournament_registrations = @tournament.registrations
    seeded_participants_id_array = helpers.seed_players(@tournament.players).map { |p| p.id }
    seeded_participants_id_array.each_with_index do |id, i|
      tournament_registrations.find_by(player_id: id).set_list_position(i+1)
    end
    redirect_to tournament_path(id: @tournament.id, anchor: 'players')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    def check_if_admin
      unless current_user.is_admin
        respond_to do |format|
          format.html { redirect_to @tournament, alert: t('flash.alert.unauthorized') }
          format.json { render json: @tournament.errors, status: :unauthorized }
        end
      end
    end

    def check_registration_deadline_is_less_than_date(tp)
      return true if tp['subtype'] == 'external'
      date = Time.new(tp['date(1i)'], tp['date(2i)'], tp['date(3i)'],  tp['date(4i)'],  tp['date(5i)'])
      registration_deadline = Time.new(tp['registration_deadline(1i)'], tp['registration_deadline(2i)'], tp['registration_deadline(3i)'],  tp['registration_deadline(4i)'],  tp['registration_deadline(5i)'])
      if registration_deadline >= date
        @tournament.errors.add(:registration_deadline, t('tournaments.errors.registration_deadline'))
        return false
      else
        return true
      end
    end

    def generate_weekly_name(city, date)
      "SSBU Weekly #{city} KW#{Date.parse(date.to_s).cweek} #{date.year}"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :date, :registration_deadline,
        :location, :description, :registration_fee, :total_seats,
        :host_username, :setup, :started, :finished, :active, :created_at,
        :updated_at, :subtype, :city, :end_date, :external_registration_link,
        :total_needed_game_stations, :min_needed_registrations, :ranking_string,
        :is_registration_allowed, :number_of_pools)
    end

    def set_challonge_username_and_api_key
      host_user = @tournament.host
      if host_user.present? and host_user.challonge_username.present? and host_user.challonge_api_key.present?
        Challonge::API.username = host_user.challonge_username
        Challonge::API.key = host_user.challonge_api_key
        return true
      elsif current_user.challonge_username.present? and current_user.challonge_api_key.present?
        Challonge::API.username = current_user.challonge_username
        Challonge::API.key = current_user.challonge_api_key
        return true
      else
        Challonge::API.username = ENV['CHALLONGE_USERNAME']
        Challonge::API.key = ENV['CHALLONGE_API_KEY']
        return false
      end
    end

end
