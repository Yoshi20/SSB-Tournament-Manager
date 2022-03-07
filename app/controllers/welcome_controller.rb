class WelcomeController < ApplicationController
  before_action { @section = 'welcome' }

  # GET /welcome
  # GET /welcome.json
  def index
    @donations = Donation.all_from(session['country_code']).where(is_public: true).order(Arel.sql('amount::float DESC')).limit(6)
    render "index_#{session['country_code']}"
  end

end
