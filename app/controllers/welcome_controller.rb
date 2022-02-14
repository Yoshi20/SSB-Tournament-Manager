class WelcomeController < ApplicationController
  before_action { @section = 'welcome' }

  # GET /welcome
  # GET /welcome.json
  def index
    @donations = Donation.all_ch.where(is_public: true).order('amount::float DESC').limit(6)
  end

end
