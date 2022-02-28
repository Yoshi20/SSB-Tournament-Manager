class DonationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /donations
  def index
    if current_user.present? && current_user.super_admin?
      @donations = Donation.all_from(session['country_code']).order(created_at: :desc)
    else
      @donations = Donation.all_from(session['country_code']).where(is_public: true).order(created_at: :desc)
    end
  end

  # POST /donation.json
  def donation
    @donation = Donation.new(donation_params)
    @donation.shop_items = donation_params[:shop_items].to_s if donation_params[:shop_items].present?
    if @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_CH']
      @donation.country_code = 'ch'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_DE']
      @donation.country_code = 'de'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_FR']
      @donation.country_code = 'fr'
    end
    respond_to do |format|
      if @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN']
        if @donation.save
          format.json { head :ok }
        else
          format.json { head :unprocessable_entity }
        end
      else
        format.json { head :unauthorized }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def donation_params
    ActionController::Parameters.new(JSON.parse(params[:data])).permit(
      :message_id, :timestamp, :type, :is_public,
      :from_name, :message, :amount, :url, :email, :currency,
      :is_subscription_payment, :is_first_subscription_payment,
      :kofi_transaction_id, :verification_token, :shop_items, :tier_name
    )
  end

end
