class TeamsController < ApplicationController
  before_action { @section = 'teams' }
  before_action :set_team, only: %i[ show edit update destroy add_player remove_player ]
  before_action :authenticate_admin!, only: [:new, :edit, :create, :update, :destroy]

  # GET /teams or /teams.json
  def index
    @teams = Team.all_from(session['country_code']).includes(:players)
  end

  # GET /teams/1 or /teams/1.json
  def show
    discord_keys = @team.discord.split(',').map(&:strip)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /teams/new
  def new
    @team = Team.new
    @team.country_code = session['country_code']
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)
    @team.country_code = session['country_code']
    @team.user_id = current_user.id
    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: t('flash.notice.team_created') }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @team, notice: t('flash.notice.team_updated') }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to communities_path, notice: t('flash.notice.team_deleted') }
      format.json { head :no_content }
    end
  end

  # POST /teams/add_player/1
  def add_player
    player_to_add = Player.find_by(gamer_tag: params[:gamer_tag])
    player_to_add = AlternativeGamerTag.find_by(gamer_tag: params[:gamer_tag]).try(:player) if player_to_add.nil?
    if player_to_add.nil?
      redirect_to @team, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.player_not_found')}"
      return;
    end
    if @team.players.include?(player_to_add)
      redirect_to @team, alert: "#{t('flash.alert.add_player_failed')} -> #{t('flash.alert.player_already_added')}"
      return;
    end
    @team.players << player_to_add
    redirect_to @team, notice: t('flash.notice.add_player_to_team')
  end

  # POST /teams/remove_player/1
  def remove_player
    player_to_remove = Player.find_by(gamer_tag: params[:gamer_tag])
    player_to_remove = AlternativeGamerTag.find_by(gamer_tag: params[:gamer_tag]).try(:player) if player_to_remove.nil?
    if player_to_remove.nil?
      redirect_to @team, alert: "#{t('flash.alert.remove_player_failed')} -> #{t('flash.alert.player_not_found')}"
      return;
    end
    if !@team.players.include?(player_to_remove)
      redirect_to @team, alert: "#{t('flash.alert.remove_player_failed')} -> #{t('flash.alert.player_not_in_tournament')}"
      return;
    end
    @team.players.delete(player_to_remove)
    redirect_to @team, notice: t('flash.notice.remove_player_from_team')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name_long, :name_short, :description,
        :website, :discord, :twitter, :instagram, :facebook, :youtube, :twitch,
        :image_link, :image_height, :image_width, :region,
        :is_sponsoring_players, :is_recruiting, :recruiting_description)
    end

    def authenticate_admin!
      unless current_user.present? && current_user.admin?
        respond_to do |format|
          format.html { redirect_to teams_path, alert: t('flash.alert.unauthorized') }
          format.json { render json: {}, status: :unauthorized }
        end
      end
    end
end
