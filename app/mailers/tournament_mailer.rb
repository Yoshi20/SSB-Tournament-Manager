class TournamentMailer < ApplicationMailer

  def new_tournament_email
    @tournament = params[:tournament]
    @url  = "https://ssb-tournament-manager.herokuapp.com/tournaments/#{@tournament.id}"
    Player.all.each do |p|
      @user = p.user
      mail(to: @user.email, subject: "A new tournament was added: #{@tournament.name}")
    end
  end

end
