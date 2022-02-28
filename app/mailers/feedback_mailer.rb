class FeedbackMailer < ApplicationMailer

  def new_feedback_email
    feedback = params[:feedback]
    admin = params[:admin]
    @user = feedback.user
    @url  = "https://www.swisssmash.ch/feedbacks/#{feedback.id}"
    mail(to: admin.email, from: from(@user.country_code), subject: "A new feedback or question was added")
  end

  def feedback_response_email
    feedback = params[:feedback]
    @admin = params[:admin]
    @user = feedback.user
    @url  = "https://www.swisssmash.ch/feedbacks/#{feedback.id}"
    mail(to: @user.email, from: from(@user.country_code), subject: "Your feedback or question was answered")
  end

end
