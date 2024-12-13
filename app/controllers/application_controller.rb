class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken do |ex|
    redirect_to new_user_session_path, alert: t('flash.alert.login_failed')
  end

  no_user_exceptions = [
    :index, :show, :location, :unregistered, :contact, :donation,
    :nrw, :hessen, :nds, :bayern, :berlin, :norden, :osten, :bawu,
    :regions, :character_discords
  ]

  before_action :set_country_code, except: :donation
  before_action :set_locale
  before_action :set_color_theme
  around_action :set_time_zone
  before_action :authenticate_user!, except: no_user_exceptions
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  before_action :set_streamers
  before_action :set_survey
  before_action :set_top_players
  before_action :get_latest_news
  before_action :get_next_tournaments
  before_action :set_forum_unread_count, only: no_user_exceptions
  before_action :prepare_exception_notifier
  after_action :set_response_language_header

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation,
      :remember_me, :challonge_username, :challonge_api_key, :full_name,
      :mobile_number, :area_of_responsibility, :is_club_member,
      :wants_major_email, :wants_weekly_email, :region,
      :gender, :birth_year, :prefix, :discord_username, :twitter_username,
      :instagram_username, :youtube_video_ids, :allows_emails_from_swisssmash,
      :allows_emails_from_germanysmash, :allows_emails_from_francesmash,
      :allows_emails_from_luxsmash, :allows_emails_from_italysmash,
      :allows_emails_from_smashiceland, :allows_emails_from_calismash,
      :allows_emails_from_partners,
      :country_code, :smash_gg_id, :nintendo_friend_code, :twitch_username,
      :role_list, :gender_pronouns]
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
    return unless Rails.env.production? # blup: only request streamers in production
    return unless ['de', 'fr', 'lu', 'it', 'uk', 'pt', 'us_ca'].include?(session['country_code'])
    lu_streamers = ["LETzSmash_SSB", "sweetspotasbl", "lestv_lu", "derladefehler", "El_Arbok"] if session['country_code'] == 'lu'
    bearer_token = request_twitch_token()
    @streamers_json = Rails.cache.fetch("streamers_#{session['country_code']}", expires_in: 1.minute) do
      url = "https://api.twitch.tv/helix/streams?game_id=504461"
      if session['country_code'] == 'lu'
        lu_streamers.each do |twitch_username|
          url = url + "&user_login=#{twitch_username}"
        end
      else
        url = url + "&language=#{Domain.default_locale_from(session['country_code'])}"
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

  def set_survey
    @survey = Survey.active.last
  end

  def set_top_players
    return unless ['ch', 'is'].include?(session['country_code'])
    top_players_method_str = "top_players_s2_23_#{session['country_code']}" if session['country_code'] == 'is'
    top_players_method_str = "top_players_s1_24_#{session['country_code']}" if session['country_code'] == 'ch'
    @topPlayers = Rails.cache.fetch(top_players_method_str, expires_in: 1.day) do
      @topPlayers = []
      helpers.send(top_players_method_str).each do |p|
        player = Player.find_by(gamer_tag: p)
        player = AlternativeGamerTag.find_by(gamer_tag: p).try(:player) if player.nil?
        @topPlayers << player unless player.nil?
        break if @topPlayers.size >= 15 # limit(12)
      end
      @topPlayers
    end
  end

  def get_latest_news
    return unless ['ch', 'fr', 'uk', 'is'].include?(session['country_code'])
    # @latest_news = News.all_from(session['country_code']).where("created_at >= ?", Time.zone.now.beginning_of_year-30.days).order(created_at: :desc).limit(3)
    @latest_news = News.all_from(session['country_code']).order(created_at: :desc).limit(3)
    @highlight_first_news = (cookies['latest_news_id'] != @latest_news.first.id.to_s)if @latest_news.present?
  end

  def get_next_tournaments
    if session['country_code'] == 'uk'
      # The UK only wants to display tournaments on the weekends
      sa1 = Time.zone.now.end_of_week.midnight - 1.day # 00:00 at Saturday
      su1 = Time.zone.now.end_of_week                  # 3:59 at Sunday
      sa2 = sa1 + 7.days
      su2 = su1 + 7.days
      sa3 = sa2 + 7.days
      su3 = su2 + 7.days
      sa4 = sa3 + 7.days
      su4 = su3 + 7.days
      @nextTournaments = Tournament.all_from(session['country_code']).active.upcoming_with_today
      @nextTournaments = @nextTournaments.where("(date >= ? AND date <= ?) OR (date >= ? AND date <= ?) OR (date >= ? AND date <= ?) OR (date >= ? AND date <= ?)", sa1, su1, sa2, su2, sa3, su3, sa4, su4)
      @nextTournaments = @nextTournaments.order(date: :asc).limit(10)
    else
      @nextTournaments = Tournament.all_from(session['country_code']).active.upcoming_with_today.order(date: :asc).limit(10)
    end
  end

  def set_forum_unread_count
    return unless current_user.present? && ['de', 'fr' 'it', 'pt'].include?(session['country_code'])
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
      elsif request.host.include?("italysmash")
        session['country_code'] = 'it'
      elsif request.host.include?("uksmash") || request.host.include?("smashultimate.co.uk") || request.host.include?("smashultimate.uk")
        session['country_code'] = 'uk'
      elsif request.host.include?("smashbrosportugal")
        session['country_code'] = 'pt'
      elsif request.host.include?("smashiceland")
        session['country_code'] = 'is'
      elsif request.host.include?("ca-smash")
        session['country_code'] = 'us_ca'
      elsif cookies['country_code'].present?
        if ['ch', 'de', 'fr', 'lu', 'it', 'uk', 'pt', 'is', 'us_ca'].include?(cookies['country_code'])
          session['country_code'] = cookies['country_code']
        else
          raise "Invalid country_code!"
        end
      else
        raise "Couldn't set country_code!"
      end
    end

    def set_locale
      available_locales = Domain.available_locales_from(session['country_code'])
      if params[:locale].present?
        cookies.permanent[:locale] = params[:locale]
      end
      localeCookie = cookies[:locale]
      if localeCookie.present? && available_locales.include?(localeCookie)
        I18n.locale = localeCookie
      else
        I18n.locale = http_accept_language.compatible_language_from(available_locales)
        cookies.permanent[:locale] = I18n.locale.to_s
      end
    end

    def set_color_theme
      return unless request.get?
      if params[:color_theme].present?
        cookies.permanent[:color_theme] = params[:color_theme]
      end
    end

    def set_time_zone
      if session['country_code'] == 'uk' || session['country_code'] == 'pt' || session['country_code'] == 'is'
        Time.use_zone("London") { yield }
      elsif session['country_code'] == 'us_ca'
        Time.use_zone("Pacific Time (US & Canada)") { yield }
      else
        yield
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

    def authenticate_super_admin!
      unless (current_user.present? && current_user.super_admin?)
        render_forbidden
        return
      end
    end

    def render_forbidden(path = root_path)
      respond_to do |format|
        format.html { redirect_to path, alert: t('flash.alert.unauthorized') }
        format.json { render json: { status: 'error', message: t('flash.alert.unauthorized') }, status: :forbidden }
      end
    end

end
