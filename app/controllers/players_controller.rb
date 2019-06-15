class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action { @section = 'players' }

  # GET /players
  # GET /players.json
  def index
    # @players = Player.all.includes(:user).sort_by do |p|
    #   [p.win_loss_ratio, -p.created_at.to_i]
    # end.reverse
    @players = Player.all.order(created_at: :desc)
  end

  # GET /players/1
  # GET /players/1.json
  def show
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
      old_gamer_tag = @player.gamer_tag
      if @player.update(player_params)

        # update main_characters
        @player.main_characters.clear
        player_params[:main_characters].split(',').each do |char|
          @player.main_characters << char.strip.downcase.gsub(' ', '_')
        end
        @player.save

        # update all tournament ranking_strings if the gamer_tag was changed
        if @player.gamer_tag != old_gamer_tag
          Tournament.all.each do |t|
            if t.ranking_string.to_s.include?(old_gamer_tag)
              t.update(ranking_string: t.ranking_string.gsub(old_gamer_tag, @player.gamer_tag))
            end
          end
        end

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
      params.require(:player).permit(:gamer_tag, :points, :participations,
        :self_assessment, :tournament_experience, :comment, :best_rank, :wins,
        :losses, :main_characters, :created_at, :updated_at, :canton, :gender,
        :birth_year)
    end

end
