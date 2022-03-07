class RegistrationsController < ApplicationController

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    registration = Registration.find(params[:id])
    respond_to do |format|
      if registration.update(registration_params)
        format.html { redirect_to registration.tournament, notice: t('flash.notice.updating_registration') }
        format.json { render json: registration, status: :ok, location: registration }
      else
        format.html { redirect_to registration.tournament, alert: t('flash.alert.updating_registration') }
        format.json { render json: registration.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def registration_params
      params.require(:registration).permit(:player_id, :tournament_id, :game_stations, :paid_fee)
    end

end
