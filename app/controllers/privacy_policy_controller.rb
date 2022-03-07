class PrivacyPolicyController < ApplicationController
  before_action { @section = 'privacy_policy' }

  # GET /privacy_policy
  # GET /privacy_policy.json
  def index
    render "index_#{session['country_code']}"
  end

end
