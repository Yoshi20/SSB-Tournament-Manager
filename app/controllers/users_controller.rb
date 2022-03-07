class UsersController < ApplicationController
  before_action :authenticate_user!
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
      if current_user.super_admin? and @user.update(user_params)
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

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:is_admin, :is_club_member, :updated_at)
  end

end
