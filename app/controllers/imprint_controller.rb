class ImprintController < ApplicationController
  before_action { @section = 'imprint' }

  # GET /imprint
  # GET /imprint.json
  def index
    render "index_#{session['country_code']}"
  end

end
