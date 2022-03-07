class ContactMailer < ApplicationMailer

  def contact_email
    @body = params[:body]
    mail(from: params[:email], to: from(params[:country_code]), subject: "Message from #{params[:name]}")
  end

end
