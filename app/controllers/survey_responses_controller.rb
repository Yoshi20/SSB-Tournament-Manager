class SurveyResponsesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_survey_response, only: %i[ update ]

  # POST /survey_responses
  def create
    @survey_response = SurveyResponse.new(survey_response_params)
    @survey_response.client_ip = request.remote_ip
    @survey_response.country_code = session['country_code']
    if @survey_response.save
      redirect_back_or_to root_path#, notice: 'Thank you for your opinion! :)'
    else
      redirect_back_or_to root_path, alert: 'Saving survey_response failed! :('
    end
  end

  # PATCH/PUT /survey_responses/1
  def update
    @survey_response.update(survey_response_params)
    redirect_back_or_to root_path unless @survey_response.is_hidden
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey_response
      @survey_response = SurveyResponse.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def survey_response_params
      params.require(:survey_response).permit(:response, :survey_id, :is_hidden)
    end

end
