class Shop::Stripe::WebhooksController < Shop::Stripe::StripeController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

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
        shop_order.complete!(current_app_mode) # reduce stocks and send some emails
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
# stripe trigger checkout.session.completed --add checkout_session:metadata.order_id=40
# stripe trigger checkout.session.async_payment_succeeded --add checkout_session:metadata.order_id=40
# stripe trigger checkout.session.async_payment_failed --add checkout_session:metadata.order_id=40
