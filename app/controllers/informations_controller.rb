class InformationsController < ApplicationController
  before_action { @section = 'informations' }

  # GET /informations
  # GET /informations.json
  def index
    render "index_#{session['country_code']}"
  end

end
