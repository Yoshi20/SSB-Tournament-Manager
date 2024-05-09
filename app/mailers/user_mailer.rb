class UserMailer < ApplicationMailer

  def welcome_email
    @user = User.find(params[:user_id])
    @url = tournaments_url(@user.country_code, '')
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(
        to: @user.email,
        from: Domain.email_from(@user.country_code),
        subject: t("users.mailer.welcome_#{@user.country_code}", locale: @locale),
        delivery_method_options: Domain.delivery_options_from(@user.country_code)
      )
    end
  end

end
