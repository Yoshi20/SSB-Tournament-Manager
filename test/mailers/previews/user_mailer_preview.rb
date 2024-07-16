# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user_id: User.where(country_code:'fr').first.id).welcome_email
  end
end
