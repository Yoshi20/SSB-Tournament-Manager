class FeedbackMailer < ApplicationMailer

  def new_feedback_email
    feedback = params[:feedback]
    admin = params[:admin]
    @user = feedback.user
    @url  = feedbacks_url(@user.country_code, feedback.id.to_s)
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(
        to: admin.email,
        from: Domain.email_from(@user.country_code),
        subject: "A new feedback or question was added",
        delivery_method_options: Domain.delivery_options_from(@user.country_code)
      )
    end
  end

  def feedback_response_email
    feedback = params[:feedback]
    @admin = params[:admin]
    @user = feedback.user
    @url  = feedbacks_url(@user.country_code, feedback.id.to_s)
    I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
      mail(
        to: @user.email,
        from: Domain.email_from(@user.country_code),
        subject: "Your feedback or question was answered",
        delivery_method_options: Domain.delivery_options_from(@user.country_code)
      )
    end
  end

  private

  def feedbacks_url(country_code, path)
    "https://www.#{Domain.domain_from(country_code)}/feedbacks/" + path
  end

end
