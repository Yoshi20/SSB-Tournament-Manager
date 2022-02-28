class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @url  = 'https://www.swisssmash.ch/tournaments'
    mail(to: @user.email, from: from(@tournament.country_code), subject: 'Welcome to the SwissSmash Tournament Manager')
  end

end
