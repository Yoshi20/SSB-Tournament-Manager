class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]
  before_action { @section = 'users' }

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order(points: :desc)
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if current_user.admin?
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

end
