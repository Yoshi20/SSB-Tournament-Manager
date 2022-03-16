class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  def from(country_code)
    if country_code == 'ch'
      'SwissSmash <admin@swisssmash.ch>'
    elsif country_code == 'de'
      'GermanySmash <admin@germanysmash.de>'
    elsif country_code == 'fr'
      'SmashUltimate.fr <admin@francesmash.fr>'
    elsif country_code == 'it'
      'ItalySmash <admin@italysmash.it>'
    end
  end

  def get_locale(country_code)
    if country_code == 'ch'
      'en'
    elsif country_code == 'de'
      'de'
    elsif country_code == 'fr'
      'fr'
    elsif country_code == 'it'
      'it'
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
    elsif country_code == 'it'
      url = 'https://www.italysmash.it/tournaments/'
    end
    url = url + path
  end

end
