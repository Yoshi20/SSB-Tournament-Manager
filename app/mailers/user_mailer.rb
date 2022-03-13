class UserMailer < ApplicationMailer

  def welcome_email
    @user = params[:user]
    @url = tournaments_url(@user.country_code, '')
    I18n.with_locale(get_locale(@user.country_code)) do
      mail(to: @user.email, from: from(@user.country_code), subject: t("users.mailer.welcome_#{@user.country_code}", locale: @locale))
    end
  end

end
