class TournamentMailer < ApplicationMailer

  def new_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, @tournament.id.to_s)
    mail(to: @user.email, from: from(@tournament.country_code), subject: "A new tournament was added: #{@tournament.name}")
  end

  def new_external_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = @tournament.external_registration_link
    mail(to: @user.email, from: from(@tournament.country_code), subject: "A new external tournament was added: #{@tournament.name}")
  end

  def new_weekly_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, @tournament.id.to_s)
    mail(to: @user.email, from: from(@tournament.country_code), subject: "One or more weeklies were added: #{@tournament.name}")
  end

  def tournament_cancelled_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, '')
    mail(to: @user.email, from: from(@tournament.country_code), subject: "Tournament was cancelled: #{@tournament.name.gsub('(cancelled) ', '')}")
  end

  def waiting_player_upgraded_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, @tournament.id.to_s)
    mail(to: @user.email, from: from(@tournament.country_code), subject: "You was upgraded from the waiting list")
  end

  def invalid_date_email
    @tournament = params[:tournament]
    @url = tournaments_url(@tournament.country_code, "#{@tournament.id}/edit")
    mail(to: from(@tournament.country_code), from: from(@tournament.country_code), subject: "External tournament with invalid date")
  end

  private

  def tournaments_url(country_code, path)
    url = ''
    if country_code == 'ch'
      url = 'https://www.swisssmash.ch/tournaments/'
    elsif country_code == 'de'
      url = 'https://www.germanysmash.de/tournaments/'
    elsif country_code == 'fr'
      url = 'https://www.smashultimate.fr/tournaments/'
    end
    url = url + path
  end

end
