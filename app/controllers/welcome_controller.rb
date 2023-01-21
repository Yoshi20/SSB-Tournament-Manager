class WelcomeController < ApplicationController
  before_action { @section = 'welcome' }

  # GET /welcome
  # GET /welcome.json
  def index
    if current_user.present? && current_user.super_admin?
      @donations = Donation.all_from(session['country_code']).order(Arel.sql('amount::float DESC')).limit(6)
    else
      @donations = Donation.all_from(session['country_code']).where(is_public: true).order(Arel.sql('amount::float DESC')).limit(6)
    end
    render "index_#{session['country_code']}"
  end

end
