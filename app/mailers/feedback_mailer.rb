class FeedbackMailer < ApplicationMailer

  def new_feedback_email
    feedback = params[:feedback]
    admin = params[:admin]
    @user = feedback.user
    @url  = feedbacks_url(@user.country_code, feedback.id.to_s)
    I18n.with_locale(get_locale(@user.country_code)) do
      mail(to: admin.email, from: from(@user.country_code), subject: "A new feedback or question was added")
    end
  end

  def feedback_response_email
    feedback = params[:feedback]
    @admin = params[:admin]
    @user = feedback.user
    @url  = feedbacks_url(@user.country_code, feedback.id.to_s)
    I18n.with_locale(get_locale(@user.country_code)) do
      mail(to: @user.email, from: from(@user.country_code), subject: "Your feedback or question was answered")
    end
  end

  private


  def feedbacks_url(country_code, path)
    url = ''
    if country_code == 'ch'
      url = 'https://www.swisssmash.ch/feedbacks/'
    elsif country_code == 'de'
      url = 'https://www.germanysmash.de/feedbacks/'
    elsif country_code == 'fr'
      url = 'https://www.smashultimate.fr/feedbacks/'
    end
    url = url + path
  end

end
