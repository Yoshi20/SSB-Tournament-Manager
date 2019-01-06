class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action { @section = 'players' }

  # GET /players
  # GET /players.json
  def index
    @players = Player.all.order(points: :desc, participations: :asc)
    @finished_tournaments_count_2019 = helpers.active_tournaments_2019.where(finished: true).count
  end

  # GET /players/1
  # GET /players/1.json
  def show
    @finished_tournaments_count_2019 = helpers.active_tournaments_2019.where(finished: true).count
  end

  # # GET /players/new
  # def new
  #   @player = Player.new
  # end

  # GET /players/1/edit
  def edit
  end

  # # POST /players
  # # POST /players.json
  # def create
  #   @player = Player.new(player_params)
  #
  #   respond_to do |format|
  #     if @player.save
  #       format.html { redirect_to @player, notice: 'Player was successfully created.' }
  #       format.json { render :show, status: :created, location: @player }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @player.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:gamer_tag, :points, :participations, :self_assessment, :tournament_experience, :comment, :best_rank, :wins, :losses, :created_at, :updated_at)
    end

end
