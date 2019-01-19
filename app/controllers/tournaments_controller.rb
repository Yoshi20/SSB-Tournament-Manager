class TournamentsController < ApplicationController
  before_action :set_tournament, except: [:index, :new, :create]
  before_action :check_if_admin, except: [:index, :show, :add_player, :remove_player]
  before_action { @section = 'tournaments' }

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = helpers.active_tournaments_2019.where('finished is not true AND date >= ?', Time.now).order(date: :asc)
    @past_tournaments = helpers.active_tournaments_2019.where('finished is true OR date < ?', Time.now).order(date: :desc)
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @game_stations_needed = helpers.max_needed_game_stations_per_tournament(@tournament.total_seats) - get_game_stations_count(@tournament)
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
    respond_to do |format|
      if check_registration_deadline_is_less_than_date(tournament_params) && @tournament.save
        Player.all.each do |p|
          TournamentMailer.with(tournament: @tournament, user: p.user).new_tournament_email.deliver_later
        end
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render :show, status: :created, location: @tournament }
      else
        format.html { render :new }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1
  # PATCH/PUT /tournaments/1.json
  def update
    # update tournament
    respond_to do |format|
      if check_registration_deadline_is_less_than_date(tournament_params) && @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { render :show, status: :ok, location: @tournament }
      else
        format.html { render :edit }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1
  # DELETE /tournaments/1.json
  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_url, notice: 'Tournament was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /tournaments/add_player/1
  def add_player
    if @tournament.occupied_seats < @tournament.total_seats
      if params[:gamer_tag].present?
        player_to_add = Player.find_by(gamer_tag: params[:gamer_tag])
      else
        player_to_add = current_user.player
      end
      if player_to_add.nil?
        redirect_to @tournament, alert: "Player couldn't be added to the tournament -> Player not found."
      elsif @tournament.players.include?(player_to_add)
        redirect_to @tournament, alert: "Player couldn't be added to the tournament -> Player was already added."
      elsif Time.now > @tournament.registration_deadline and !params[:gamer_tag].present?
        redirect_to @tournament, alert: "Player couldn't be added to the tournament -> Registration deadline exceeded."
      else
        @tournament.players << player_to_add
        @tournament.update(occupied_seats: @tournament.occupied_seats+1)
        redirect_to @tournament, notice: 'Player was added to the tournament.'
      end
    else
      redirect_to @tournament, alert: "Player couldn't be added to the tournament -> The tournament is full."
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
      redirect_to @tournament, alert: "Player couldn't be removed from the tournament -> Player not found."
    elsif !@tournament.players.include?(player_to_remove)
      redirect_to @tournament, alert: "Player couldn't be removed from the tournament -> Player is not in the tournament."
    elsif Time.now > @tournament.registration_deadline and !params[:gamer_tag].present?
      redirect_to @tournament, alert: "Player couldn't be removed from the tournament -> Registration deadline exceeded."
    else
      @tournament.players.delete(Player.find(player_to_remove.id))
      @tournament.update(occupied_seats: @tournament.occupied_seats-1)
      redirect_to @tournament, notice: 'Player was removed from the tournament.'
    end
  end

  # POST /tournaments/setup/1
  def setup
    if @tournament.setup or @tournament.started or @tournament.finished
      redirect_to @tournament, alert: 'Tournament is already set up, started or finished!'
    else
      needed_game_stations_count = helpers.max_needed_game_stations_per_tournament(@tournament.occupied_seats)
      current_game_stations_count = get_game_stations_count(@tournament)
      if current_game_stations_count < needed_game_stations_count
        delta_game_stations = needed_game_stations_count - current_game_stations_count
        redirect_to @tournament, alert: "#{delta_game_stations} more game #{delta_game_stations > 1 ? 'stations are' : 'station is'} needed to setup the tournament!"
      else
        if set_challonge_username_and_api_key()

          # setup a challonge tournament
          ct = Challonge::Tournament.new
          ct.name = @tournament.name #'SSBU Bern KW1'
          ct.url = @tournament.name.gsub(/( )/, '_').downcase #'ssbu_bern_kw1'
          ct.tournament_type = 'double elimination'
          ct.game_name = 'Super Smash Bros. Ultimate'
          ct.description = @tournament.description
          if ct.save == false
            raise ct.errors.full_messages.inspect
          end

          # sort the participants by the best player
          seeded_participants = @tournament.players.sort_by do |p|
            seed_points = (p.participations == 0 ? p.points : p.points.to_f/p.participations)
            seed_points += ((p.losses == 0) ? 0 : p.wins.to_f/(p.wins+p.losses))
            seed_points += p.self_assessment.to_f/5
            seed_points += p.tournament_experience.to_f/10
            seed_points
          end.reverse

          # add the participants to the challonge tournament
          seeded_participants.each do |p|
            Challonge::Participant.create(:name => p.gamer_tag, :tournament => ct)
          end

          @tournament.setup = true
          @tournament.challonge_tournament_id = ct.id
          @tournament.save

          redirect_to @tournament, notice: "Tournament was successfully set up. Check it out on challonge.com and click 'Start tournament' if you're ready."
        else
          redirect_to @tournament, alert: "Tournament cannot be set up. Challonge data are missing. Add them #{view_context.link_to('here', edit_user_registration_path, target: '_blank')}".html_safe
        end
      end
    end
  end

  # POST /tournaments/start/1
  def start
    if !@tournament.setup
      redirect_to @tournament, alert: "Tournament wasn't set up yet!"
    elsif @tournament.started or @tournament.finished
      redirect_to @tournament, alert: 'Tournament is already started or finished!'
    else
      if set_challonge_username_and_api_key()

        # get the correct challonge tournament
        ct = Challonge::Tournament.find(@tournament.challonge_tournament_id)

        ct.start!
        @tournament.started = true
        @tournament.save

        redirect_to @tournament, notice: 'Tournament was successfully started.'
      else
        redirect_to @tournament, alert: "Tournament cannot be started. Challonge data are missing. Add them #{view_context.link_to('here', edit_user_registration_path, target: '_blank')}".html_safe
      end
    end
  end

  # POST /tournaments/finish/1
  def finish
    if !@tournament.setup or !@tournament.started
      redirect_to @tournament, alert: "Tournament wasn't set up or started yet!"
    elsif @tournament.finished
      redirect_to @tournament, alert: 'Tournament is already finished!'
    else
      if set_challonge_username_and_api_key()

        # get the correct challonge tournament
        ct = Challonge::Tournament.find(@tournament.challonge_tournament_id)

        if ct.state == 'complete'
          # updated the participated players
          ct.participants.each do |p|
            # updated player
            player = @tournament.players.find_by(:gamer_tag => p.display_name)
            player.points += helpers.points_repartition_table(p.final_rank)
            player.participations += 1
            if player.best_rank == 0 or player.best_rank < p.final_rank then player.best_rank = p.final_rank end
            ct.matches.each do |m|
              scores = m.scores_csv.split('-')
              if m.player1_id == p.id
                player.wins += scores[0].to_i
                player.losses += scores[1].to_i
              elsif m.player2_id == p.id
                player.wins += scores[1].to_i
                player.losses += scores[0].to_i
              end
            end
            player.save

            player.update_tournament_experience

            # updated raking_string on the tournament
            ranking_string = "#{p.final_rank},#{p.display_name};"
            @tournament.ranking_string += ranking_string
          end
          @tournament.finished = true
          @tournament.save
          redirect_to @tournament, notice: 'Tournament was successfully finished and the participated players were updated.'
        else
          if ct.started_at.nil? then @tournament.update(started: false) end # this happens when a ct was reset
          link = "https://challonge.com/#{ct.url}"
          redirect_to @tournament, alert: "Tournament was not fineshed yet. You have to finish it first on: #{view_context.link_to link, link, target: '_blank'}".html_safe
        end
      else
        redirect_to @tournament, alert: "Tournament cannot be finished. Challonge data are missing. Add them #{view_context.link_to('here', edit_user_registration_path, target: '_blank')}".html_safe
      end
    end
  end

  # POST /tournaments/cancel/1
  def cancel
    # send each player an email if the tournament was canceled
    @tournament.players.each do |p|
      TournamentMailer.with(tournament: @tournament, user: p.user).tournament_canceled_email.deliver_later
    end
    @tournament.update(tournament_params)
    redirect_to @tournament, notice: 'Tournament was successfully canceled.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    def check_if_admin
      unless current_user.is_admin
        respond_to do |format|
          format.html { redirect_to @tournament, alert: 'Unauthorized! You must be an administrator to make this action.' }
          format.json { render json: @tournament.errors, status: :unauthorized }
        end
      end
    end

    def check_registration_deadline_is_less_than_date(tp)
      date = Time.new(tp['date(1i)'], tp['date(2i)'], tp['date(3i)'],  tp['date(4i)'],  tp['date(5i)'])
      registration_deadline = Time.new(tp['registration_deadline(1i)'], tp['registration_deadline(2i)'], tp['registration_deadline(3i)'],  tp['registration_deadline(4i)'],  tp['date(5i)'])
      if registration_deadline >= date
        @tournament.errors.add(:registration_deadline, "must be less than date")
        return false
      else
        return true
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :date, :registration_deadline, :location, :description, :registration_fee, :occupied_seats, :total_seats, :setup, :started, :finished, :active, :created_at, :updated_at)
    end

    def set_challonge_username_and_api_key
      if current_user.challonge_username.present? and current_user.challonge_api_key.present?
        Challonge::API.username = current_user.challonge_username
        Challonge::API.key = current_user.challonge_api_key
        return true
      else
        Challonge::API.username = ENV['CHALLONGE_USERNAME']
        Challonge::API.key = ENV['CHALLONGE_API_KEY']
        return false
      end
    end

    def get_game_stations_count(tournament)
      gs_count = 0
      Registration.where(tournament_id: tournament.id).where('game_stations is not NULL').each do |r|
        gs_count += r.game_stations
      end
      gs_count
    end

end
