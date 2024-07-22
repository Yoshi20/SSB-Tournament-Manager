class Shop::Stripe::StripeController < ActionController::Base
  before_action :set_stripe_key

  protected

    def handleTransferToSellers(checkout_session)
      # checkout_session = Stripe::Checkout::Session.retrieve(params[:session_id])
      shop_order = Shop::Order.find(checkout_session.metadata.order_id)
      # blup: unless shop_order.stripe_transfer_id.present?
      transfer_data_array = JSON.parse(checkout_session.metadata.transfer_data_json)
      # make a transfer for every seller
      transfer_data_array.each do |td|
        account = Stripe::Account.retrieve(td['stripe_account_id'])
        if (account.present? && account.charges_enabled && account.details_submitted && account.payouts_enabled)
          # blup: next if account.id == "acct_1Pc88NJFjCRueizw" # no Transfer required if its my swisssmash.ch stripe account
          # Find charge_id to be able to define source_transaction (to prevent "insufficient available funds"-error)
          payment_intent = Stripe::PaymentIntent::retrieve(checkout_session.payment_intent)
          puts 'blup'
          puts payment_intent.inspect
          charge_id = payment_intent.latest_charge # TODO: handling when charge_id is (still) nil?
          puts 'blup1 <-------------'
          puts charge_id.inspect
          puts Stripe::Charge::retrieve(charge_id) #blup
          # Transfer a specific amount to a given destination (e.g. a seller account) and only leave my platform fee
          amount_for_seller = (td['price'] + td['shipping']) * (1.0 - Shop::Order::FeeInPercent) - Shop::Order::FeeFlatrate
          transfer = Stripe::Transfer.create({
            amount: (amount_for_seller * 100).to_i, # price in Rp
            currency: td['currency'],
            destination: account.id, # seller account
            transfer_group: "ORDER_#{shop_order.id}",
            metadata: { order_id: shop_order.id }, # optional
            # note: The currency of source_transaction's balance transaction (chf) must be the same as the transfer currency
            # https://docs.stripe.com/connect/separate-charges-and-transfers?platform=web&ui=stripe-hosted#verf%C3%BCgbarkeit-von-%C3%BCberweisungen
            source_transaction: (td['currency'] == 'chf' ? charge_id : nil),
            # blup: bei Euro o.ä. muss mein Stripe-Konto ein genügend grosses Guthaben vorweisen!
            # (oder trotzdem als chf schicken und vorgängig amount_for_seller anpassen?)
          })
          puts 'blup2'
          puts transfer.inspect
          # shop_order.update(stripe_transfer_id: transfer.id)
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
