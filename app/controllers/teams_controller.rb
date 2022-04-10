class TeamsController < ApplicationController
  before_action { @section = 'teams' }
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!, only: [:new, :edit, :create, :update, :destroy]

  # GET /teams or /teams.json
  def index
    @teams = Team.all_from(session['country_code']).includes(:players)
  end

  # GET /teams/1 or /teams/1.json
  def show
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
