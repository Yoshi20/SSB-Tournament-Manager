class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action { @section = 'users' }

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(:created_at)
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if current_user.admin? and @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to users_path, alert: "User couldn't be updated." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user.super_admin? or current_user == @user
      @user.player.destroy
      @user.destroy
      flash[:notice] = "User was successfully deleted"
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
