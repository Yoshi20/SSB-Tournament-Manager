class RegistrationsController < ApplicationController

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    registration = Registration.find(params[:id])
    respond_to do |format|
      if registration.update(registration_params)
        format.html { redirect_to registration.tournament, notice: 'Registration was successfully updated.' }
        format.json { render :show, status: :ok, location: registration.tournament }
      else
        format.html { redirect_to registration.tournament, alert: "Registration couldn't be updated." }
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
