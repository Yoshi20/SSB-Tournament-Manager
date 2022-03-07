class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @locale = get_locale(@user.country_code)
    @url = tournaments_url(@user.country_code, '')
    mail(to: @user.email, from: from(@user.country_code), subject: t("users.mailer.welcome_#{@user.country_code}", locale: @locale))
  end

end
