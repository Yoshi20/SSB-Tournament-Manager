class ContactController < ApplicationController

  # POST /contact
  def contact
    respond_to do |format|
      if verify_recaptcha(secret_key: ENV["RECAPTCHA_SECRET_KEY_#{session['country_code'].upcase}"], message: t('flash.alert.contact'))
        if params[:email].present? && params[:body].present?
          ContactMailer.with(name: params[:name], email: params[:email], body: params[:body], country_code: session['country_code']).contact_email.deliver_later
          format.html { redirect_to informations_path(anchor: 'contact'), notice: t('flash.notice.contact') }
        else
          format.html { redirect_to informations_path(anchor: 'contact', name: params[:name], email: params[:email], body: params[:body] ), alert: t('flash.alert.contact_invalid') }
        end
      else
        format.html { redirect_to informations_path(anchor: 'contact', name: params[:name], email: params[:email], body: params[:body] ) }
      end
    end
  end

end
