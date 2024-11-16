require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SsbTournamentManager
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.insert_before ActionDispatch::Static, Rack::Deflater # to compress (gzip) static assets

    config.time_zone = 'Bern'

    config.i18n.available_locales = %w(en de fr it pt is)

    config.apps = {
      ch: "SwissSmash",
      de: "GermanySmash",
      fr: "SmashUltimate",
      lu: "LuxSmash",
      it: "ItalySmash",
      uk: "SmashUltimate",
      pt: "SmashBrosPortugal",
      is: "SmashIceland",
      us_ca: "CaliSmash",
    }

    config.domains = {
      ch: "swisssmash.ch",
      de: "germanysmash.de",
      fr: "smashultimate.fr",
      lu: "luxsmash.lu",
      it: "italysmash.it",
      uk: "smashultimate.uk",
      pt: "smashbrosportugal.com",
      is: "smashiceland.com",
      us_ca: "ca-smash.com",
    }

    config.default_locales = {
      ch: "en",
      de: "de",
      fr: "fr",
      lu: "en",
      it: "it",
      uk: "en",
      pt: "pt",
      is: "is",
      us_ca: "en",
    }

    config.available_locales = {
      ch: ["en", "de", "fr"],
      de: ["en", "de"],
      fr: ["en", "fr"],
      lu: ["en", "de", "fr"],
      it: ["en", "it"],
      uk: ["en"],
      pt: ["en", "pt"],
      is: ["en", "is"],
      us_ca: ["en"],
    }

    config.currencies = {
      ch: "CHF",
      de: "€",
      fr: "€",
      lu: "€",
      it: "€",
      uk: "£",
      pt: "€",
      is: "kr",
      us_ca: "$",
    }

    config.iso_currencies = {
      ch: "chf",
      de: "eur",
      fr: "eur",
      lu: "eur",
      it: "eur",
      uk: "gbp",
      pt: "eur",
      is: "isk",
      us_ca: "usd",
    }

    config.emails = {
      ch: "SwissSmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_CH']}>",
      de: "GermanySmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_DE']}>",
      fr: "SmashUltimate.fr <#{ENV['INFOMANIAK_EMAIL_USERNAME_FR']}>",
      lu: "LuxSmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_LU']}>",
      it: "ItalySmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_IT']}>",
      uk: "SmashUltimate.uk <#{ENV['INFOMANIAK_EMAIL_USERNAME_UK']}>",
      pt: "SmashBrosPortugal <#{ENV['INFOMANIAK_EMAIL_USERNAME_PT']}>",
      is: "SmashIceland <#{ENV['INFOMANIAK_EMAIL_USERNAME_IS']}>",
      us_ca: "CaliSmash <#{ENV['INFOMANIAK_EMAIL_USERNAME_US_CA']}>",
    }

    config.smtp_hosts = {
      ch: "mail.infomaniak.com",
      de: "mail.infomaniak.com",
      fr: "mail.infomaniak.com",
      lu: "mail.infomaniak.com",
      it: "mail.infomaniak.com",
      uk: "mail.infomaniak.com",
      pt: "mail.infomaniak.com",
      is: "mail.infomaniak.com",
      us_ca: "mail.infomaniak.com",
    }

    config.smtp_domains = {
      ch: "swisssmash.ch",
      de: "germanysmash.de",
      fr: "francesmash.fr",
      lu: "luxsmash.lu",
      it: "italysmash.it",
      uk: "smashultimate.uk",
      pt: "smashbrosportugal.com",
      is: "smashiceland.com",
      us_ca: "ca-smash.com",
    }

    config.smtp_user_names = {
      ch: ENV['INFOMANIAK_EMAIL_USERNAME_CH'],
      de: ENV['INFOMANIAK_EMAIL_USERNAME_DE'],
      fr: ENV['INFOMANIAK_EMAIL_USERNAME_FR'],
      lu: ENV['INFOMANIAK_EMAIL_USERNAME_LU'],
      it: ENV['INFOMANIAK_EMAIL_USERNAME_IT'],
      uk: ENV['INFOMANIAK_EMAIL_USERNAME_UK'],
      pt: ENV['INFOMANIAK_EMAIL_USERNAME_PT'],
      is: ENV['INFOMANIAK_EMAIL_USERNAME_IS'],
      us_ca: ENV['INFOMANIAK_EMAIL_USERNAME_US_CA'],
    }

    config.smtp_passwords = {
      ch: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      de: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      fr: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      lu: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      it: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      uk: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      pt: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      is: ENV['INFOMANIAK_EMAIL_PASSWORD'],
      us_ca: ENV['INFOMANIAK_EMAIL_PASSWORD'],
    }

    config.stripe = {
      public_key: ENV["STRIPE_API_KEY_PUBLIC"],
      secret_key: ENV["STRIPE_API_KEY_SECRET"],
      webhook_secret: ENV["STRIPE_WEBHOOK_SECRET"],
    }

  end
end
