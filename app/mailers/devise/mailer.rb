if defined?(ActionMailer)
  class Devise::Mailer < Devise.parent_mailer.constantize
    include Devise::Mailers::Helpers

    def confirmation_instructions(record, token, opts = {})
      @token = token
      opts = getCountrySpecificSender(record)
      devise_mail(record, :confirmation_instructions, opts)
    end

    def reset_password_instructions(record, token, opts = {})
      @token = token
      opts = getCountrySpecificSender(record)
      devise_mail(record, :reset_password_instructions, opts)
    end

    def unlock_instructions(record, token, opts = {})
      @token = token
      opts = getCountrySpecificSender(record)
      devise_mail(record, :unlock_instructions, opts)
    end

    def email_changed(record, opts = {})
      opts = getCountrySpecificSender(record)
      devise_mail(record, :email_changed, opts)
    end

    def password_change(record, opts = {})
      opts = getCountrySpecificSender(record)
      devise_mail(record, :password_change, opts)
    end

    private

    def getCountrySpecificSender(record)
      initialize_from_record(record)
      email = Domain.email_from(@resource.country_code)
      {
        from: email,
        reply_to: email,
        delivery_method_options: Domain.delivery_options_from(@resource.country_code)
      }
    end

  end
end
