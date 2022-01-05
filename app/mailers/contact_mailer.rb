class ContactMailer < ApplicationMailer

  def contact_email
    @body = params[:body]
    mail(from: params[:email], to: 'admin@germanysmash.de', subject: "Nachricht von #{params[:name]}")
  end

end
