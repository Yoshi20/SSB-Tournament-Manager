# Preview all emails at http://localhost:3000/rails/mailers/tournament_mailer
class TournamentMailerPreview < ActionMailer::Preview
  def new_tournament_email
    TournamentMailer.with(tournament: Tournament.where(subtype: 'internal').first, user: User.first).new_tournament_email
  end

  def new_external_tournament_email
    TournamentMailer.with(tournament: Tournament.where(subtype: 'external').first, user: User.first).new_external_tournament_email
  end

  def new_weekly_tournament_email
    TournamentMailer.with(tournament: Tournament.where(subtype: 'weekly').first, user: User.first).new_weekly_tournament_email
  end

  def tournament_canceled_email
    TournamentMailer.with(tournament: Tournament.where('started is FALSE or started is NULL AND finished is TRUE').first, user: User.first).tournament_canceled_email
  end

  def waiting_player_upgraded_email
    TournamentMailer.with(tournament: Tournament.first, user: User.first).waiting_player_upgraded_email
  end

end
