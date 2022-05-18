include Recaptcha::Adapters::ViewMethods
include Recaptcha::Adapters::ControllerMethods

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
    # if verify_recaptcha(secret_key: ENV["RECAPTCHA_SECRET_KEY_#{session['country_code'].upcase}"], action: 'registration', minimum_score: 0.3)
    if verify_recaptcha(secret_key: ENV["RECAPTCHA_SECRET_KEY_#{session['country_code'].upcase}"])
      user_params = Hash.new
      super do |current_user_params|
        user_params = current_user_params
      end
      user = User.find_by(email: user_params[:email])
      if user.present? && user.id == user_params[:id]
        # User seems to be created successfully -> Create a new player and assign it to this user
        player = Player.new
        player.country_code = user.country_code
        player.gamer_tag = params[:gamer_tag]
        player.prefix = params[:prefix]
        player.discord_username = params[:discord_username]
        player.twitter_username = params[:twitter_username]
        player.instagram_username = params[:instagram_username]
        player.youtube_video_ids = params[:youtube_video_ids]
        player.twitch_username = params[:twitch_username]
        player.nintendo_friend_code = params[:nintendo_friend_code]
        player.smash_gg_id = params[:smash_gg_id]
        player.points = 0
        player.participations = 0
        player.region = params[:region]
        player.gender = params[:gender]
        player.gender_pronouns = params[:gender_pronouns]
        player.birth_year = params[:birth_year]
        player.self_assessment = params[:self_assessment] || 0
        player.tournament_experience = params[:tournament_experience] || 0
        main_characters = [
          params[:main_char1].present? ? params[:main_char1][0] : nil,
          params[:main_char2].present? ? params[:main_char2][0] : nil,
          params[:main_char3].present? ? params[:main_char3][0] : nil
        ]
        main_characters.each do |char|
          player.main_characters << char
        end
        main_character_skins = [
          params[:main_char_skin1].present? ? params[:main_char_skin1][0].to_i : nil,
          params[:main_char_skin2].present? ? params[:main_char_skin2][0].to_i : nil,
          params[:main_char_skin3].present? ? params[:main_char_skin3][0].to_i : nil
        ]
        main_character_skins.each do |skin_nr|
          player.main_character_skins << skin_nr
        end
        player.comment = params[:comment]
        player.best_rank = 0
        player.wins = 0
        player.losses = 0
        player.user = user
        player.role_list = params[:role_list].compact.reject { |c| c.empty? } if params[:role_list].present?
        if player.save
          flash[:notice] = t('flash.notice.creating_player')
          # Tell the UserMailer to send a welcome email after save
          UserMailer.with(user: user).welcome_email.deliver_later
        else
          flash.delete(:notice)
          flash[:alert] = t('flash.alert.creating_player')
          user.destroy
        end
      else
        # nothing to do here (Render or redirect was already called in super)
      end
    else
      self.resource = resource_class.new sign_up_params
      resource.validate
      respond_with_navigational(resource) { render :new }
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
  #   user_params = Hash.new
  #   super do |current_user_params|
  #     user_params = current_user_params
  #   end
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
    players_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def after_update_path_for(resource)
    player_path(resource.player)
  end

end
