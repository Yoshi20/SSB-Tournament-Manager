class ContactMailer < ApplicationMailer

  def contact_email
    @from = params[:email]
    @body = params[:body]
    mail(
      from: Domain.email_from(params[:country_code]),
      to: Domain.email_from(params[:country_code]),
      subject: "Message from #{params[:name]}",
      delivery_method_options: Domain.delivery_options_from(params[:country_code])
    )
  end

end
