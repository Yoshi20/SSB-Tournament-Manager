# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action { @section = 'account' }
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    user_params = Hash.new
    super do |current_user_params|
      user_params = current_user_params
    end
    user = User.last
    if user.id == user_params[:id]
      # User seems to be created successfully -> Create a new player and assign it to this user
      player = Player.new
      player.gamer_tag = params[:gamer_tag]
      player.prefix = params[:prefix]
      player.discord_username = params[:discord_username]
      player.points = 0
      player.participations = 0
      player.canton = params[:canton]
      player.gender = params[:gender]
      player.birth_year = params[:birth_year]
      player.self_assessment = params[:self_assessment] || 0
      player.tournament_experience = params[:tournament_experience] || 0
      params[:main_characters].split(',').each do |char|
        player.main_characters << char.strip.downcase.gsub(' ', '_')
      end
      player.comment = params[:comment]
      player.best_rank = 0
      player.wins = 0
      player.losses = 0
      player.user = user
      if player.save
        flash[:notice] = "Player was successfully created"
        # Tell the UserMailer to send a welcome email after save
        UserMailer.with(user: user).welcome_email.deliver_later
      else
        flash.delete(:notice)
        flash[:alert] = "Creating player failed!"
        user.delete
      end
    end
  end

  # GET /resource/edit
  def edit
    super
    if params[:id].nil?
      @user = current_user
    else
      @user = User.find(params[:id])
    end
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    players_path()
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
