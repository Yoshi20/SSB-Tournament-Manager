class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  def tournaments_url(country_code, path)
    "https://www.#{Domain.domain_from(country_code)}/tournaments/" + path
  end

end
