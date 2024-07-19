class Shop::Stripe::WebhooksController < Shop::Stripe::StripeController

  # POST /shop/stripe/webhook
  def webhook
    payload = request.body.read
    signature_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = Rails.application.config.stripe[:webhook_secret] # 'whsec_...'
    event = nil
    begin
      event = Stripe::Webhook.construct_event(payload, signature_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      render json: {message: e}, status: 400
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render json: {message: e}, status: 400
      return
    end
    # Handle the event
    case event.type
    when 'checkout.session.completed', 'checkout.session.async_payment_succeeded'
      checkout_session = event.data.object
      if checkout_session.payment_status == 'paid'
        shop_order = ShopOrder.find(checkout_session.metadata.order_id)
        shop_order.update!(was_order_paid: true)
        shop_order.complete! # reduce stocks and send some emails
        handleTransferToSellers(checkout_session)
      end
    # when 'checkout.session.async_payment_failed' # payment failed
    else
      puts "Unhandled event type: #{event.type}"
    end
    render json: {}, status: 200
  end

private

  def handleTransferToSellers(checkout_session)
    # checkout_session = Stripe::Checkout::Session.retrieve(params[:session_id])
    shop_order = ShopOrder.find(checkout_session.metadata.order_id)
    transfer_data_array = JSON.parse(checkout_session.metadata.transfer_data_json)
    # make a transfer for every seller
    transfer_data_array.each do |td|
      account = Stripe::Account.retrieve(td['stripe_account_id'])
      if (account.present? && account.charges_enabled && account.details_submitted && account.payouts_enabled)
        # Find charge_id to be able to define source_transaction (to prevent "insufficient available funds"-error)
        payment_intend = Stripe::PaymentIntent::retrieve(checkout_session.payment_intent)
        charge_id = payment_intend.latest_charge # TODO: handling when charge_id is (still) nil?
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

end

# To test locally (using the Stripe CLI):
# (once) stripe login
# (in a seperate tab) stripe listen --forward-to localhost:3000/shop/stripe/webhook
# (once) set webhook_secret (shown after stripe listen)
# stripe trigger checkout.session.completed --add checkout_session:metadata.order_id=40
# stripe trigger checkout.session.async_payment_succeeded --add checkout_session:metadata.order_id=40
# stripe trigger checkout.session.async_payment_failed --add checkout_session:metadata.order_id=40
