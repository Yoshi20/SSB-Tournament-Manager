class RulesController < ApplicationController
  before_action { @section = 'rules' }

  # GET /rules
  # GET /rules.json
  def index
    render "index_#{session['country_code']}"
  end

end
