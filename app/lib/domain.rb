module Domain

  def self.domain_from(country_code)
    Rails.application.config.domains[country_code.to_sym]
  end

  def self.email_from(country_code)
    Rails.application.config.emails[country_code.to_sym]
  end

  def self.default_locale_from(country_code)
    Rails.application.config.default_locales[country_code.to_sym]
  end

  def self.available_locales_from(country_code)
    Rails.application.config.available_locales[country_code.to_sym]
  end

end
