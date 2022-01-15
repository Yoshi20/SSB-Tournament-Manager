# Preview all emails at http://localhost:3000/rails/mailers/feedback_mailer
class FeedbackMailerPreview < ActionMailer::Preview
  def new_feedback_email
    FeedbackMailer.with(feedback: Feedback.first, admin: User.all_ch.where(is_admin:true).first).new_feedback_email
  end

  def feedback_response_email
    FeedbackMailer.with(feedback: Feedback.first, admin: User.all_ch.where(is_admin:true).first).feedback_response_email
  end

end
