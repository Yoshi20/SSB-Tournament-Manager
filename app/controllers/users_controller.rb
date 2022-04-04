class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:index]
  before_action :set_user, only: [:update, :destroy]
  before_action { @section = 'users' }

  # GET /users
  # GET /users.json
  def index
    @users = User.all_from(session['country_code']).includes(:player).order(created_at: :desc).paginate(page: params[:page], per_page: User::MAX_USERS_PER_PAGE)
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      prev_country_code = @user.country_code
      if current_user.super_admin? and @user.update(user_params)
        # country_code update handling
        if user_params['country_code'].present? && user_params['country_code'] != prev_country_code
          @user.player.update(country_code: user_params['country_code'])
          @user.player.alternative_gamer_tags.each do |agt|
            agt..update(country_code: user_params['country_code'])
          end
          @user.news.each do |n|
            n.update(country_code: user_params['country_code'])
          end
          @user.feedbacks.each do |f|
            f.update(country_code: user_params['country_code'])
          end
        end
        format.html { redirect_to users_path, notice: t('flash.notice.updating_user') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to users_path, alert: t('flash.alert.updating_user') }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user.super_admin? or current_user == @user
      @user.player.destroy if @user.player.present?
      @user.destroy
      flash[:notice] = t('flash.notice.deleting_user')
    else
      raise 'impossibru!'
    end
    redirect_to users_path
  end

  private

  def authenticate_admin!
    unless current_user.present? && current_user.admin?
      respond_to do |format|
        if current_user.present?
          format.html { redirect_to edit_user_registration_path }
          format.json { render json: edit_user_registration_path.errors, status: :unauthorized }
        else
          format.html { redirect_to root_path, alert: t('flash.alert.unauthorized') }
          format.json { render json: {}, status: :unauthorized }
        end
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:is_admin, :is_club_member, :updated_at, :country_code)
  end

end
