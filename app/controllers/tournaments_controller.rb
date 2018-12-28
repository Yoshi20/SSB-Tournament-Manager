class TournamentsController < ApplicationController
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :start]
  before_action { @section = 'tournaments' }

  # GET /tournaments
  # GET /tournaments.json
  def index
    @tournaments = Tournament.all.where(active: true).where("? > ?", :date, Time::now).order(date: :asc)
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
          @tournament.players << current_user.player
          @tournament.update(occupied_seats: @tournament.occupied_seats+1)
          redirect_to @tournament, notice: 'Player was added to the tournament.'
        else
          redirect_to @tournament, alert: "Player couldn't be added to the tournament. The tournament is full."
        end
      end

      if params[:remove_player]
        @tournament.players.delete(Player.find(current_user.player.id))
        @tournament.update(occupied_seats: @tournament.occupied_seats-1)
        redirect_to @tournament, notice: 'Player was removed from the tournament.'
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
    # TODO: Add challonge-api as a dependency for your project and set your username and API key on startup.
    Challonge::API.username = 'Yoshi20'
    Challonge::API.key = 'CRgTBcoqMDnObv1XKKTz4ge3UDQeN5hMmtEszxjM'

    # setup and start a challonge tournament
    ct = Challonge::Tournament.new
    ct.name = @tournament.name #'SSBU Bern KW 1'
    ct.url = @tournament.name.gsub(/( )/, '_').downcase #'ssbu_bern_kw_1'
    ct.tournament_type = 'double elimination'
    ct.game_name = 'Super Smash Bros. Ultimate'
    ct.description = @tournament.comment
    if ct.save == false
      raise ct.errors.full_messages.inspect
    end

    # add the participants
    @tournament.players.each do |p|
    	Challonge::Participant.create(:name => p.gamer_tag, :tournament => ct)
    end

    ct.start!

    #TODO: add_started_to_tournaments
    #@tournament.update(started: true)

    #TODO: show tournament tree in the show view

    redirect_to @tournament, notice: 'Tournament was successfully started.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tournament_params
      params.require(:tournament).permit(:name, :date, :location, :comment, :registration_fee, :occupied_seats, :total_seats, :active, :created_at, :updated_at)
    end
end
