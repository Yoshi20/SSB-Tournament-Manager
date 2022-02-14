class DonationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /donation.json
  def donation
    @donation = Donation.new(donation_params)
    @donation.shop_items = donation_params[:shop_items].to_s if donation_params[:shop_items].present?
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
    params.require(:donation).permit(:message_id, :timestamp, :type, :is_public,
      :from_name, :message, :amount, :url, :email, :currency,
      :is_subscription_payment, :is_first_subscription_payment,
      :kofi_transaction_id, :verification_token, :shop_items, :tier_name)
  end

end
