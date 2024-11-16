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
    @donation = Donation.new(donation_params.except(:type))
    @donation.subtype = donation_params[:type] # the column 'type' is reserved for storing the class in case of inheritance
    @donation.shop_items = donation_params[:shop_items].to_s if donation_params[:shop_items].present?
    if @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_CH']
      @donation.country_code = 'ch'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_DE']
      @donation.country_code = 'de'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_FR']
      @donation.country_code = 'fr'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_LU']
      @donation.country_code = 'lu'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_IT']
      @donation.country_code = 'it'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_UK']
      @donation.country_code = 'uk'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_PT']
      @donation.country_code = 'pt'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_IS']
      @donation.country_code = 'is'
    elsif @donation.verification_token == ENV['KO_FI_VERIFICATION_TOKEN_US_CA']
      @donation.country_code = 'us_ca'
    end
    respond_to do |format|
      if @donation.country_code.present? # to check verification
        if @donation.save
          format.json { head :ok }
        else
          format.json { head :unprocessable_content }
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
