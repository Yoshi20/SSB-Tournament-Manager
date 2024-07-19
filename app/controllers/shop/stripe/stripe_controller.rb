class Shop::Stripe::StripeController < ActionController::Base
  before_action :set_stripe_key

  protected

    def handleTransferToSellers(checkout_session)
      # checkout_session = Stripe::Checkout::Session.retrieve(params[:session_id])
      shop_order = Shop::Order.find(checkout_session.metadata.order_id)
      transfer_data_array = JSON.parse(checkout_session.metadata.transfer_data_json)
      # make a transfer for every seller
      transfer_data_array.each do |td|
        account = Stripe::Account.retrieve(td['stripe_account_id'])
        if (account.present? && account.charges_enabled && account.details_submitted && account.payouts_enabled)
          # Find charge_id to be able to define source_transaction (to prevent "insufficient available funds"-error)
          payment_intend = Stripe::PaymentIntent::retrieve(checkout_session.payment_intent)
          charge_id = payment_intend.latest_charge # TODO: handling when charge_id is (still) nil?
          # Transfer a specific amount to a given destination (e.g. a seller account) and only leave my platform fee
          amount_for_seller = (td['price'] + td['shipping']) * (1.0 - (0.0325 + 0.05)) - 0.3 # Stripe-Fee: 3.25% + 0.3 + Platform-Fee: 5%
          transfer = Stripe::Transfer.create({
            amount: (amount_for_seller * 100).to_i, # price in Rp
            currency: td['currency'],
            destination: account.id, # seller account
            transfer_group: "ORDER_#{shop_order.id}",
            source_transaction: charge_id, # https://docs.stripe.com/connect/separate-charges-and-transfers?platform=web&ui=stripe-hosted#verf%C3%BCgbarkeit-von-%C3%BCberweisungen
            metadata: { order_id: shop_order.id } # optional
          })
        else
          #TODO: handle invalid payout account
          raise "invalid Stripe payout account! -> #{account.inspect}"
        end
      end
    end

  private

    def set_stripe_key
      Stripe.api_key = Rails.application.config.stripe[:secret_key]
    end

end
