class TournamentMailer < ApplicationMailer

  def new_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, @tournament.id.to_s)
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(to: @user.email, from: Domain.email_from(@tournament.country_code), subject: "A new tournament was added: #{@tournament.name}")
    end
  end

  def new_external_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = @tournament.external_registration_link || ''
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(to: @user.email, from: Domain.email_from(@tournament.country_code), subject: "A new external tournament was added: #{@tournament.name}")
    end
  end

  def new_weekly_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, @tournament.id.to_s)
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(to: @user.email, from: Domain.email_from(@tournament.country_code), subject: "One or more weeklies were added: #{@tournament.name}")
    end
  end

  def tournament_cancelled_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, '')
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(to: @user.email, from: Domain.email_from(@tournament.country_code), subject: "Tournament was cancelled: #{@tournament.name.gsub('(cancelled) ', '')}")
    end
  end

  def waiting_player_upgraded_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = tournaments_url(@tournament.country_code, @tournament.id.to_s)
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(to: @user.email, from: Domain.email_from(@tournament.country_code), subject: "You was upgraded from the waiting list")
    end
  end

  def invalid_date_email
    @tournament = params[:tournament]
    @url = tournaments_url(@tournament.country_code, "#{@tournament.id}/edit")
    mail(to: Domain.email_from(@tournament.country_code), from: Domain.email_from(@tournament.country_code), subject: "External tournament with invalid date")
  end

end
