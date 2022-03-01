class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  def from(country_code)
    if country_code == 'ch'
      'SwissSmash <admin@swisssmash.ch>'
    elsif country_code == 'de'
      'GermanySmash <admin@germanysmash.de>'
    elsif country_code == 'fr'
      'SmashUltimate.fr <admin@francesmash.fr>'
    end
  end

  def get_locale(country_code)
    if country_code == 'ch'
      'en'
    elsif country_code == 'de'
      'de'
    elsif country_code == 'fr'
      'fr'
    end
  end

  def tournaments_url(country_code, path)
    url = ''
    if country_code == 'ch'
      url = 'https://www.swisssmash.ch/tournaments/'
    elsif country_code == 'de'
      url = 'https://www.germanysmash.de/tournaments/'
    elsif country_code == 'fr'
      url = 'https://www.smashultimate.fr/tournaments/'
    end
    url = url + path
  end

end
