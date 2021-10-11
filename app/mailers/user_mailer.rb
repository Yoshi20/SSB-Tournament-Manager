class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @url  = 'https://www.swisssmash.ch/tournaments'
    mail(to: @user.email, subject: 'Welcome to the SwissSmash Tournament Manager')
  end

end
