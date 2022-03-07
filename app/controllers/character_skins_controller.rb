class CharacterSkinsController < ApplicationController

  # GET /character_skins.js
  def show
    respond_to do |format|
      format.js {
        render partial: 'players/character_skins', locals: {
          character: params[:character],
          skin_nr: params[:skin_nr],
          current_character_skin_nr: params[:current_character_skin_nr]
        }, layout: false
      }
    end
  end

end
