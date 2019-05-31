class TournamentMailer < ApplicationMailer

  def new_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = "https://www.swisssmash.ch/tournaments/#{@tournament.id}"
    mail(to: @user.email, subject: "A new tournament was added: #{@tournament.name}")
  end

  def new_external_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = @tournament.external_registration_link
    mail(to: @user.email, subject: "A new external tournament was added: #{@tournament.name}")
  end

  def new_weekly_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = "https://www.swisssmash.ch/tournaments/#{@tournament.id}"
    mail(to: @user.email, subject: "One or more weeklies were added: #{@tournament.name}")
  end

  def tournament_cancelled_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = "https://www.swisssmash.ch/tournaments"
    mail(to: @user.email, subject: "Tournament was cancelled: #{@tournament.name.gsub('(cancelled) ', '')}")
  end

  def waiting_player_upgraded_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = "https://www.swisssmash.ch/tournaments/#{@tournament.id}"
    mail(to: @user.email, subject: "You was upgraded from the waiting list")
  end

  def invalid_date_email
    @tournament = params[:tournament]
    @url = "https://www.swisssmash.ch/tournaments/#{@tournament.id}/edit"
    mail(to: 'admin@swisssmash.ch', subject: "External tournament with invalid date")
  end

end
