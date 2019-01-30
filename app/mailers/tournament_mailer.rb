class TournamentMailer < ApplicationMailer

  def new_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = "https://ssb-tournament-manager.herokuapp.com/tournaments/#{@tournament.id}"
    mail(to: @user.email, subject: "A new tournament was added: #{@tournament.name}")
  end

  def new_external_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = @tournament.external_registration_link
    mail(to: @user.email, subject: "A new external tournament was added: #{@tournament.name}")
  end

  def tournament_canceled_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = "https://ssb-tournament-manager.herokuapp.com/tournaments"
    mail(to: @user.email, subject: "Tournament was canceled: #{@tournament.name.gsub('(canceled) ', '')}")
  end

  def waiting_player_upgraded_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url = "https://ssb-tournament-manager.herokuapp.com/tournaments/#{@tournament.id}"
    mail(to: @user.email, subject: "You was upgraded from the waiting list")
  end

end
