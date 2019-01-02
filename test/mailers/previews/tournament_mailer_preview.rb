# Preview all emails at http://localhost:3000/rails/mailers/tournament_mailer
class TournamentMailerPreview < ActionMailer::Preview
  def new_tournament_email
    TournamentMailer.with(tournament: Tournament.first, user: User.first).new_tournament_email
  end
end
