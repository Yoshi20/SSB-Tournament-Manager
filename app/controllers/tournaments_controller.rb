class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :setup, :start, :finish]
  before_action { @section = 'tournaments' }

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = helpers.active_tournaments_2019.where('finished is not true').order(date: :asc)
    @finished_tournaments = helpers.active_tournaments_2019.where(finished: true).order(date: :desc)
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
    @game_stations_needed = helpers.max_needed_game_stations_per_tournament(@tournament.total_seats) - get_game_stations_count(@tournament)
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
      if @tournament.save
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
    # add a game station to a Registration
    if params[:tournament].present? and params[:tournament][:game_stations]
      pt = @tournament.registrations.where(player_id: current_user.player.id).first
      if pt.game_stations.nil? then pt.game_stations = 0 end
      if pt.game_stations < helpers.max_needed_game_stations_per_tournament(@tournament.total_seats)
        pt.update(game_stations: params[:tournament][:game_stations])
      end
    end

    # send each player a mail if the tournament was canceled
    if params[:tournament].present? and params[:tournament][:cancel]
      @tournament.players.each do |p|
        TournamentMailer.with(tournament: @tournament, user: p.user).tournament_canceled_email.deliver_later
      end
    end

    # add/remove players to/from the tournament
    if params[:add_player] or params[:remove_player]
      if params[:add_player]
        if @tournament.occupied_seats < @tournament.total_seats
          if params[:gamer_tag].present?
            player_to_add = Player.find_by(gamer_tag: params[:gamer_tag])
          else
            player_to_add = current_user.player
          end
          if player_to_add.nil?
            redirect_to @tournament, alert: "Player couldn't be added to the tournament -> Player not found."
          elsif @tournament.players.include?(player_to_add)
            redirect_to @tournament, alert: "Player couldn't be added to the tournament -> Player already added."
          elsif Time.now > helpers.registration_deadline(@tournament.date) and !params[:gamer_tag].present?
            redirect_to @tournament, alert: "Player couldn't be added to the tournament -> Registration deadline exceeded."
          else
            @tournament.players << player_to_add
            @tournament.update(occupied_seats: @tournament.occupied_seats+1)
            redirect_to @tournament, notice: 'Player was added to the tournament.'
          end
        else
          redirect_to @tournament, alert: "Player couldn't be added to the tournament -> The tournament is full."
        end
      elsif params[:remove_player]
        if params[:gamer_tag].present?
          player_to_remove = Player.find_by(gamer_tag: params[:gamer_tag])
        else
          player_to_remove = current_user.player
        end
        if player_to_remove.nil?
          redirect_to @tournament, alert: "Player couldn't be removed from the tournament -> Player not found."
        elsif !@tournament.players.include?(player_to_remove)
          redirect_to @tournament, alert: "Player couldn't be removed from the tournament -> Player not in the tournament."
        elsif Time.now > helpers.registration_deadline(@tournament.date) and !params[:gamer_tag].present?
          redirect_to @tournament, alert: "Player couldn't be removed from the tournament -> Registration deadline exceeded."
        else
          @tournament.players.delete(Player.find(player_to_remove.id))
          @tournament.update(occupied_seats: @tournament.occupied_seats-1)
          redirect_to @tournament, notice: 'Player was removed from the tournament.'
        end
      end
    else
      # update tournament
      respond_to do |format|
        if @tournament.update(tournament_params)
          format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
          format.json { render :show, status: :ok, location: @tournament }
        else
          format.html { render :edit }
          format.json { render json: @tournament.errors, status: :unprocessable_entity }
        end
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
        set_challonge_username_and_api_key()

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
      set_challonge_username_and_api_key()

      # get the correct challonge tournament
      ct = Challonge::Tournament.find(@tournament.challonge_tournament_id)

      ct.start!
      @tournament.started = true
      @tournament.save

      redirect_to @tournament, notice: 'Tournament was successfully started.'
    end
  end

  # POST /tournaments/finish/1
  def finish
    if !@tournament.setup or !@tournament.started
      redirect_to @tournament, alert: "Tournament wasn't set up or started yet!"
    elsif @tournament.finished
      redirect_to @tournament, alert: 'Tournament is already finished!'
    else
      set_challonge_username_and_api_key()

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
        redirect_to @tournament, alert: "Tournament was not fineshed yet. You have to finish it first on: https://challonge.com/#{ct.url}"
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :date, :location, :description, :registration_fee, :occupied_seats, :total_seats, :setup, :started, :finished, :active, :created_at, :updated_at)
    end

    def set_challonge_username_and_api_key
      Challonge::API.username = ENV['CHALLONGE_USERNAME']
      Challonge::API.key = ENV['CHALLONGE_API_KEY']
    end

    def get_game_stations_count(tournament)
      pt_count = 0
      Registration.where(tournament_id: tournament.id).where('game_stations is not NULL').each do |pt|
        pt_count += pt.game_stations
      end
      pt_count
    end

end
