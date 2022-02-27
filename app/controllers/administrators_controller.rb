class AdministratorsController < ApplicationController
  before_action { @section = 'administrators' }

  # GET /administrators
  # GET /administrators.json
  def index
    @admins = User.all_from(session['country_code']).where(is_admin: true).order(:area_of_responsibility)
  end

end
