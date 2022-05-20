require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SSBTournamentManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'Bern'

    config.i18n.available_locales = %w(en de fr it)

    config.domains = {
      ch: "swisssmash.ch",
      de: "germanysmash.de",
      fr: "smashultimate.fr",
      lu: "luxsmash.lu",
      it: "italysmash.it",
      uk: "smashultimate.uk",
    }

    config.default_locales = {
      ch: "en",
      de: "de",
      fr: "fr",
      lu: "en",
      it: "it",
      uk: "en",
    }

    config.available_locales = {
      ch: ["en", "de", "fr"],
      de: ["en", "de"],
      fr: ["en", "fr"],
      lu: ["en", "de", "fr"],
      it: ["en", "it"],
      uk: ["en"],
    }

    config.currencies = {
      ch: "CHF",
      de: "€",
      fr: "€",
      lu: "€",
      it: "€",
      uk: "£",
    }

    config.emails = {
      ch: "SwissSmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_CH']}>",
      de: "GermanySmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_DE']}>",
      fr: "SmashUltimate.fr <#{ENV['INFOMANIAK_EMAIL_USERNAME_FR']}>",
      lu: "LuxSmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_LU']}>",
      it: "ItalySmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_IT']}>",
      uk: "SmashUltimate.uk <#{ENV['INFOMANIAK_EMAIL_USERNAME_UK']}>",
    }

    config.smtp_hosts = {
      ch: "mail.infomaniak.com",
      de: "mail.infomaniak.com",
      fr: "mail.infomaniak.com",
      lu: "ssl0.ovh.net",
      it: "mail.infomaniak.com",
      uk: "mail.infomaniak.com",
    }

    config.smtp_domains = {
      ch: "swisssmash.ch",
      de: "germanysmash.de",
      fr: "francesmash.fr",
      lu: "letz-smash.lu",
      it: "italysmash.it",
      uk: "smashultimate.uk",
    }

    config.smtp_user_names = {
      ch: ENV['INFOMANIAK_EMAIL_USERNAME_CH'],
      de: ENV['INFOMANIAK_EMAIL_USERNAME_DE'],
      fr: ENV['INFOMANIAK_EMAIL_USERNAME_FR'],
      lu: ENV['INFOMANIAK_EMAIL_USERNAME_LU'],
      it: ENV['INFOMANIAK_EMAIL_USERNAME_IT'],
      uk: ENV['INFOMANIAK_EMAIL_USERNAME_UK'],
    }

    config.smtp_passwords = {
      ch: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      de: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      fr: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      lu: ENV['INFOMANIAK_EMAIL_PASSWORD_LU'],
      it: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      uk: ENV['INFOMANIAK_EMAIL_PASSWORD'],
    }

  end
end
