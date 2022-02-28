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

end
