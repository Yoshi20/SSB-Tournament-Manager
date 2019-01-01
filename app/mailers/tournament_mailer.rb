class TournamentMailer < ApplicationMailer

  def new_tournament_email
    @tournament = params[:tournament]
    @url  = "https://ssb-tournament-manager.herokuapp.com/tournaments/#{@tournament.id}"
    @tournament.players.each do |p|
      @user = p.user
      mail(to: @user.email, subject: 'A new tournament was added')
    end
  end

end
