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

    config.i18n.available_locales = %w(en de fr lu it)

    config.domains = {
      ch: "swisssmash.ch",
      de: "germanysmash.de",
      fr: "smashultimate.fr",
      lu: "luxsmash.lu",
      it: "italysmash.it",
    }

    config.country_locales = {
      ch: "en",
      de: "de",
      fr: "fr",
      lu: "en",
      it: "it",
    }

    config.emails = {
      ch: "SwissSmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_CH']}>",
      de: "GermanySmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_DE']}>",
      fr: "SmashUltimate.fr <#{ENV['INFOMANIAK_EMAIL_USERNAME_FR']}>",
      lu: "LuxSmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_LU']}>",
      it: "ItalySmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_IT']}>",
    }

  end
end
