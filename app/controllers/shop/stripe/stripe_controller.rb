class Shop::Stripe::StripeController < ActionController::Base
  before_action :set_stripe_key

  protected

    def handleTransferToSellers(checkout_session)
      shop_order = Shop::Order.find(checkout_session.metadata.order_id)
      transfer_data_array = JSON.parse(checkout_session.metadata.transfer_data_json)
      # make a transfer for every seller
      transfer_data_array.each do |td|
        seller_order = shop_order.seller_orders.find_by(stripe_account_id: td['stripe_account_id'])
        next if seller_order.stripe_transfer_id.present? # prevents creating multiple Stripe::Transfer
        account = Stripe::Account.retrieve(td['stripe_account_id'])
        if (account.present? && account.charges_enabled && account.details_submitted && account.payouts_enabled)
          # blup: TODO -> next if account.id == "acct_1Pc88NJFjCRueizw" # no Transfer required if its my swisssmash.ch stripe account
          # Find charge_id to be able to define source_transaction (to prevent "insufficient available funds"-error)
          payment_intent = Stripe::PaymentIntent::retrieve(checkout_session.payment_intent)
          # puts payment_intent.inspect
          charge_id = payment_intent.latest_charge # TODO: handling when charge_id is (still) nil?
          # charge = Stripe::Charge::retrieve(charge_id)
          # balance_transaction = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
          # Transfer a specific amount to a given destination (e.g. a seller account) and only leave my platform fee
          # https://docs.stripe.com/connect/separate-charges-and-transfers?platform=web&ui=stripe-hosted#verf%C3%BCgbarkeit-von-%C3%BCberweisungen
          # Note: The currency of source_transaction's balance transaction must be the same as the transfer currency
          # => This means that for ever currency a matching bank account is required -> https://dashboard.stripe.com/settings/payouts
          total_price = (td['price'] + td['shipping'])
          amount_for_seller = total_price * (1.0 - Shop::Order::FeeInPercent) - Shop::Order::FeeFlatrate/transfer_data_array.count
          transfer = Stripe::Transfer.create({
            amount: (amount_for_seller * 100).to_i, # price in Rp
            currency: td['currency'],
            destination: account.id, # seller account
            transfer_group: "ORDER_#{shop_order.id}",
            metadata: { order_id: shop_order.id }, # optional
            source_transaction: charge_id, # optional (used to prevent "insufficient available funds"-error)
          })
          # puts transfer.inspect
          seller_order.update(stripe_transfer_id: transfer.id)
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
