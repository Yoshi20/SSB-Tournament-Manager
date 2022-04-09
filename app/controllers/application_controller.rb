class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken, with: :rescue_invalid_auth_token

  no_user_exceptions = [
    :index, :show, :location, :unregistered, :contact, :donation,
    :nrw, :hessen, :nds, :bayern, :berlin, :norden, :osten, :bawu,
    :grand_est, :nouvelle_aquitaine, :auvergne_rhone_alpes,
    :bourgogne_franche_comte, :bretagne, :centre_val_de_loire, :corsica,
    :paris_region, :occitanie, :hauts_de_france, :normandie, :pays_de_la_loire,
    :provence_alpes_cote_azur, :character_discords
  ]

  before_action :set_country_code, except: :donation
  before_action :set_locale
  before_action :authenticate_user!, except: no_user_exceptions
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  before_action :set_streamers
  before_action :set_top_players
  before_action :get_next_tournaments
  before_action :set_forum_unread_count, only: no_user_exceptions
  before_action :prepare_exception_notifier
  after_action :set_response_language_header

  protected

  def configure_permitted_parameters
    #new
    added_attrs = [:username, :email, :password, :password_confirmation,
      :remember_me, :challonge_username, :challonge_api_key, :full_name,
      :mobile_number, :area_of_responsibility, :is_club_member,
      :wants_major_email, :wants_weekly_email, :region,
      :gender, :birth_year, :prefix, :discord_username, :twitter_username,
      :instagram_username, :youtube_video_ids, :allows_emails_from_swisssmash,
      :allows_emails_from_germanysmash, :allows_emails_from_francesmash,
      :allows_emails_from_luxsmash,
      :allows_emails_from_partners, :country_code, :smash_gg_id,
      :nintendo_friend_code, :twitch_username]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def user_for_paper_trail
    current_user.try(:username)
  end

  def after_sign_in_path_for(resource)
    if request.referer.nil? or request.referer.include?('/users/')
     root_path
    else
     request.referer
    end
  end

  def after_sign_out_path_for(resource)
    request.referrer
  end

  require 'open-uri'
  require 'json'
  def set_streamers
    return unless session['country_code'] == 'de' || session['country_code'] == 'fr' || session['country_code'] == 'lu'
    lu_streamers = ["Letzsmash_SSB", "sweetspotasbl", "lestv_lu", "derladefehler"] if session['country_code'] == 'lu'
    bearer_token = request_twitch_token()
    @streamers_json = Rails.cache.fetch("streamers_#{session['country_code']}", expires_in: 1.minute) do
      url = "https://api.twitch.tv/helix/streams?game_id=504461"
      if session['country_code'] == 'lu'
        lu_streamers.each do |twitch_username|
          url = url + "&user_login=#{twitch_username}"
        end
      else
        url = url + "&language=#{session['country_code']}"
      end
      puts "Requesting: GET #{url}"
      begin
        json_data = JSON.parse(URI.open(url,
          "Authorization" => "Bearer #{bearer_token}",
          "Client-Id" => ENV['TWITCH_CLIENT_ID']
        ).read)
      rescue OpenURI::HTTPError => ex
        puts ex
      end
      if json_data.present? && !json_data["data"].nil?
        json_data["data"]
      else
        puts "=> No data parameter found! json_data = #{json_data.to_s}"
        Rails.cache.delete("twitch_token")
        break # do not cache if theres no valid data
      end
    end

    if session['country_code'] == 'lu'
      all_streamer_logins = @streamers_json.map { |s| s['user_login']}
      @inactive_streamers = lu_streamers.reject{ |s| all_streamer_logins.include?(s) }
    end
  end

  def set_top_players
    return unless session['country_code'] == 'ch'
    Rails.cache.delete("top_players_s12_21")
    @topPlayers = Rails.cache.fetch("top_players_s12_21", expires_in: 1.day) do
      @topPlayers = []
      helpers.top_players_s12_21.each do |p|
        player = Player.find_by(gamer_tag: p)
        player = AlternativeGamerTag.find_by(gamer_tag: p).try(:player) if player.nil?
        @topPlayers << player unless player.nil?
        break if @topPlayers.size >= 12 # limit(12)
      end
      @topPlayers
    end
  end

  def get_next_tournaments
    @nextTournaments = Tournament.all_from(session['country_code']).active.upcoming_with_today.order(date: :asc).includes(:players).limit(10)
  end

  def set_forum_unread_count
    return unless current_user.present? && (session['country_code'] == 'de' || session['country_code'] == 'fr')
    @forum_unread_count = Thredded::Topic.all.joins(:messageboard).merge(Thredded::Messageboard.where(country_code: session['country_code'])).unread(current_user).count
  end

  private

    def set_country_code
      if request.host.include?("swisssmash")
        session['country_code'] = 'ch'
      elsif request.host.include?("germanysmash")
        session['country_code'] = 'de'
      elsif request.host.include?("francesmash") || request.host.include?("smashultimate.fr")
        session['country_code'] = 'fr'
      elsif request.host.include?("luxsmash")
        session['country_code'] = 'lu'
      elsif cookies['country_code'].present?
        if ['ch', 'de', 'fr', 'lu'].include?(cookies['country_code'])
          session['country_code'] = cookies['country_code']
        else
          raise "Invalid country_code!"
        end
      else
        raise "Couldn't set country_code!"
      end
    end

    def set_locale
      if params[:locale].present?
        cookies.permanent[:locale] = params[:locale]
      end
      localeCookie = cookies[:locale]
      if localeCookie.present?
        I18n.locale = localeCookie
      else
        I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
        cookies.permanent[:locale] = I18n.locale.to_s
      end
    end

    def set_response_language_header
        response.headers["Content-Language"] = I18n.locale.to_s
    end

    def prepare_exception_notifier
      request.env["exception_notifier.exception_data"] = {
        current_user: current_user
      }
    end

    def rescue_invalid_auth_token
      redirect_to new_user_session_path, alert: t('flash.alert.login_failed')
    end

    require 'net/http'
    def request_twitch_token
      Rails.cache.fetch("twitch_token") do
        url = "https://id.twitch.tv/oauth2/token"
        puts "Requesting: POST #{url}"
        begin
          response = Net::HTTP.post_form(URI.parse(url), {
            client_id: ENV['TWITCH_CLIENT_ID'],
            client_secret: ENV['TWITCH_CLIENT_SECRET'],
            grant_type: "client_credentials"
          })
          json_data = JSON.parse(response.body) if response.present?
        rescue OpenURI::HTTPError => ex
          puts ex
        end
        if json_data.present? && !json_data["access_token"].nil?
          json_data["access_token"]
        else
          puts "=> No access_token parameter found! json_data = #{json_data.to_s}"
          break # do not cache if theres no valid data
        end
      end
    end

end
