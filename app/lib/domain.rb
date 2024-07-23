module Domain

  def self.title_from(country_code)
    Rails.application.config.apps[country_code.to_sym]
  end

  def self.domain_from(country_code)
    Rails.application.config.domains[country_code.to_sym]
  end

  def self.email_from(country_code)
    Rails.application.config.emails[country_code.to_sym]
  end

  def self.default_locale_from(country_code)
    return "en" if country_code.nil?
    Rails.application.config.default_locales[country_code.to_sym]
  end

  def self.available_locales_from(country_code)
    return ["en"] if country_code.nil?
    Rails.application.config.available_locales[country_code.to_sym]
  end

  def self.currency_from(country_code)
    return '$' if country_code.nil?
    Rails.application.config.currencies[country_code.to_sym]
  end

  def self.iso_currency_from(country_code)
    # Stripe does not seem to support the Icelandic Krona as an alternative currency -> https://docs.stripe.com/payouts/alternative-currencies
    return 'eur' if country_code.nil? || country_code == 'is'
    Rails.application.config.iso_currencies[country_code.to_sym]
  end

  def self.delivery_options_from(country_code)
    {
      address: Rails.application.config.smtp_hosts[country_code.to_sym],
      port: 587, #or 25,
      domain: Rails.application.config.smtp_domains[country_code.to_sym], # must be the same as domain from sender
      user_name: Rails.application.config.smtp_user_names[country_code.to_sym],
      password: Rails.application.config.smtp_passwords[country_code.to_sym],
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end

end
