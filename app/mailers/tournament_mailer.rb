class TournamentMailer < ApplicationMailer

  def new_tournament_email
    @tournament = params[:tournament]
    @user = params[:user]
    @url  = "https://ssb-tournament-manager.herokuapp.com/tournaments/#{@tournament.id}"
    mail(to: @user.email, subject: "A new tournament was added: #{@tournament.name}")
  end

end
