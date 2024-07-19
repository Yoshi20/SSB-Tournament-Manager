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
        shop_order = Shop::Order.find(checkout_session.metadata.order_id)
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

end

# To test locally (using the Stripe CLI):
# (once) stripe login
# (in a seperate tab) stripe listen --forward-to localhost:3000/shop/stripe/webhook
# (once) set webhook_secret (shown after stripe listen)
