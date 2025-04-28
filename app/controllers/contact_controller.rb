class ContactController < ApplicationController

  # POST /contact
  def contact
    respond_to do |format|
      if verify_recaptcha(secret_key: ENV["RECAPTCHA_SECRET_KEY_#{session['country_code'].upcase}"], message: t('flash.alert.contact'))
        if params[:email].present? && params[:body].present? && !params[:url].present? # the :url is used to trick spam bots
          # also do net send anything when the message contains certain keywords
          if !(params[:body].downcase.include?('leadgeneration.com') || params[:body].downcase.include?('к')) # greek К
            ContactMailer.with(name: params[:name], email: params[:email], body: params[:body], country_code: session['country_code']).contact_email.deliver_later
          end
          format.html { redirect_to informations_path(anchor: 'contact'), notice: t('flash.notice.contact') }
        else
          format.html { redirect_to informations_path(anchor: 'contact', name: params[:name], email: params[:email], body: params[:body], url: params[:url]), alert: t('flash.alert.contact_invalid') }
        end
      else
        format.html { redirect_to informations_path(anchor: 'contact', name: params[:name], email: params[:email], body: params[:body], url: params[:url]) }
      end
    end
  end

end
