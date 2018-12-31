class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :start, :finish]
  before_action { @section = 'tournaments' }

  # GET /tournaments
  # GET /tournaments.json
  def index
    all_active_tournaments = Tournament.all.where(active: true)
    @tournaments = all_active_tournaments.where('finished is not true').order(date: :asc)
    @finished_tournaments = all_active_tournaments.where(finished: true).order(date: :desc)
  end

  # GET /tournaments/1
  # GET /tournaments/1.json
  def show
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

    respond_to do |format|
      if @tournament.save
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
          else
            @tournament.players << player_to_add
            @tournament.update(occupied_seats: @tournament.occupied_seats+1)
            redirect_to @tournament, notice: 'Player was added to the tournament.'
          end
        else
          redirect_to @tournament, alert: "Player couldn't be added to the tournament -> The tournament is full."
        end
      end

      if params[:remove_player]
        if params[:gamer_tag].present?
          player_to_remove = Player.find_by(gamer_tag: params[:gamer_tag])
        else
          player_to_remove = current_user.player
        end
        if player_to_remove.nil?
          redirect_to @tournament, alert: "Player couldn't be removed from the tournament -> Player not found."
        else
          @tournament.players.delete(Player.find(player_to_remove.id))
          @tournament.update(occupied_seats: @tournament.occupied_seats-1)
          redirect_to @tournament, notice: 'Player was removed from the tournament.'
        end
      end
    else
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

  # POST /tournaments/start/1
  def start
    set_challonge_username_and_api_key()

    # setup and start a challonge tournament
    ct = Challonge::Tournament.new
    ct.name = @tournament.name #'SSBU Bern KW 1'
    ct.url = @tournament.name.gsub(/( )/, '_').downcase #'ssbu_bern_kw_1'
    ct.tournament_type = 'double elimination'
    ct.game_name = 'Super Smash Bros. Ultimate'
    ct.description = @tournament.description
    if ct.save == false
      raise ct.errors.full_messages.inspect
    end

    # add the participants
    @tournament.players.order(points: :desc).each do |p|
    	Challonge::Participant.create(:name => p.gamer_tag, :tournament => ct)
    end

    ct.start!
    @tournament.started = true
    @tournament.challonge_tournament_id = ct.id
    @tournament.save

    redirect_to @tournament, notice: 'Tournament was successfully started.'
  end

  # POST /tournaments/finish/1
  def finish
    set_challonge_username_and_api_key()

    # get the correct challonge tournament
    ct = Challonge::Tournament.find(@tournament.challonge_tournament_id)

    if ct.state == 'complete'
      @tournament.finished = true
      # updated the participated players
      ct.participants.each do |p|
        player = @tournament.players.find_by(:gamer_tag => p.display_name)
        player.points = points_repartition_table(p.final_rank)
        player.participations += 1
        if player.participations >= 30 and player.tournament_experience < 2 then player.tournament_experience = 2
        elsif player.participations >= 10 and player.tournament_experience < 1 then player.tournament_experience = 1
        end
        player.save
        # create/updated a raking_string on the tournament
        ranking_string = "#{p.final_rank},#{p.display_name};"
        if @tournament.ranking_string.nil?
          @tournament.ranking_string = ranking_string
        else
          @tournament.ranking_string += ranking_string
        end
      end
      @tournament.save
      redirect_to @tournament, notice: 'Tournament was successfully finished and the participated players were updated.'
    else
      redirect_to @tournament, alert: "Tournament was not fineshed yet. You have to finish it first on: https://challonge.com/#{ct.url}"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :date, :location, :description, :registration_fee, :occupied_seats, :total_seats, :started, :finished, :active, :created_at, :updated_at)
    end

    def set_challonge_username_and_api_key
      # TODO: Add challonge-api as a dependency for your project and set your username and API key on startup.
      Challonge::API.username = 'Yoshi20'
      Challonge::API.key = 'CRgTBcoqMDnObv1XKKTz4ge3UDQeN5hMmtEszxjM'
    end

    def points_repartition_table(rank)
        if rank == 1 then 300
        elsif rank == 2 then 250
        elsif rank == 3 then 200
        elsif rank == 4 then 150
        elsif rank <= 6 then 100
        elsif rank <= 8 then 75
        elsif rank <= 12 then 50
        elsif rank <= 16 then 25
        elsif rank <= 24 then 15
        elsif rank <= 32 then 10
        else 5
        end
    end
end
