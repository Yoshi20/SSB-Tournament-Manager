class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @url  = 'https://ssb-tournament-manager.herokuapp.com/tournaments'
    mail(to: @user.email, subject: 'Welcome to the SSB Tournament Manager')
  end

  # def component_out_of_stock_notification_mail(anime, other_user)
  #   subject = "#{component.name} is out of stock!"
  # 	@anime = anime
  #   @user = anime.user
  #   @other_user = other_user
  #   content_type = "text/html"
  # 	mail(to: @user.email, subject: subject, content_type: content_type)
  # end

end
