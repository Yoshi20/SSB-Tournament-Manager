# Preview all emails at http://localhost:3000/rails/mailers/tournament_mailer
class TournamentMailerPreview < ActionMailer::Preview
  def new_tournament_email
    TournamentMailer.with(tournament: Tournament.all_from(session['country_code']).where(subtype: 'internal').first, user: User.first).new_tournament_email
  end

  def new_external_tournament_email
    TournamentMailer.with(tournament: Tournament.all_from(session['country_code']).where(subtype: 'external').first, user: User.first).new_external_tournament_email
  end

  def new_weekly_tournament_email
    TournamentMailer.with(tournament: Tournament.all_from(session['country_code']).where(subtype: 'weekly').first, user: User.first).new_weekly_tournament_email
  end

  def tournament_cancelled_email
    TournamentMailer.with(tournament: Tournament.all_from(session['country_code']).where('(started is FALSE or started is NULL) AND finished is TRUE').first, user: User.first).tournament_cancelled_email
  end

  def waiting_player_upgraded_email
    TournamentMailer.with(tournament: Tournament.all_from(session['country_code']).first, user: User.first).waiting_player_upgraded_email
  end

  def invalid_date_email
    TournamentMailer.with(tournament: Tournament.all_from(session['country_code']).where(subtype: 'external').first).invalid_date_email
  end

end
