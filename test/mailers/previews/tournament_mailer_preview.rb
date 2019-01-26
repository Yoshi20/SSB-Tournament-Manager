# Preview all emails at http://localhost:3000/rails/mailers/tournament_mailer
class TournamentMailerPreview < ActionMailer::Preview
  def new_tournament_email
    TournamentMailer.with(tournament: Tournament.first, user: User.first).new_tournament_email
  end

  def tournament_canceled_email
    TournamentMailer.with(tournament: Tournament.where('started is FALSE or started is NULL AND finished is TRUE').first, user: User.first).tournament_canceled_email
  end

  def waiting_player_upgraded_email
    TournamentMailer.with(tournament: Tournament.first, user: User.first).waiting_player_upgraded_email
  end

end
