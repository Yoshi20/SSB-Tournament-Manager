class FeedbackMailer < ApplicationMailer

  def new_feedback_email
    feedback = params[:feedback]
    email = params[:email]
    @user = feedback.user
    @url  = "https://ssb-feedback-manager.herokuapp.com/feedbacks/#{feedback.id}"
    mail(to: email, subject: "A new feedback was added")
  end

end
