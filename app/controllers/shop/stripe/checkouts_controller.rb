class Shop::Stripe::CheckoutsController < Shop::Stripe::StripeController
  #before_action :authenticate_user!

  # GET /shop/stripe/checkout?order_id=1
  def checkout
    shop_order = ShopOrder.find(params[:order_id])
    shopping_cart = shop_order.shopping_cart
    redirect_to shop_stripe_checkout_cancel_path if (shop_order.was_order_paid || shopping_cart.has_checked_out)
    line_items = []
    # products
    shopping_cart.shop_purchases.includes(:shop_product).order(:created_at).each do |purchase|
      line_items << {
        price_data: {
          currency: 'chf',
          product_data: {name: purchase.shop_product.name},
          unit_amount: (purchase.shop_product.price * 100).to_i, # price in Rp
        },
        quantity: purchase.quantity,
      }
    end
    # shipping (could also be handled in Stripe::Checkout::Session)
    line_items << {
      price_data: {
        currency: 'chf',
        product_data: {name: t('shopping_cart.shipment')},
        unit_amount: (shopping_cart.shipping_costs * 100).to_i, # price in Rp
      },
      quantity: 1,
    }
    # stripe fee (only add this if you want the user to pay it)
    total_price = shopping_cart.total_price
    stripe_fees = total_price * 0.03 + 0.5 # 3% + 0.5 CHF
    line_items << {
      price_data: {
        currency: 'chf',
        product_data: {name: t('shopping_cart.stripe_fees')},
        unit_amount: (stripe_fees * 100).to_i, # price in Rp
      },
      quantity: 1,
    }
    # Stripe checkout session request
    checkout_session = Stripe::Checkout::Session.create({
      line_items: line_items,
      payment_intent_data: {
        # on_behalf_of: '{{CONNECTED_ACCOUNT_ID}}',
        transfer_group: "ORDER_#{shop_order.id}",
        # application_fee_amount: 123, #blup: https://docs.stripe.com/connect/collect-then-transfer-guide?locale=de-DE&connect-account-creation-pattern=typeless
        # transfer_data: {destination: '{{CONNECTED_ACCOUNT_ID}}' },
      },
      mode: 'payment',
      success_url: (shop_stripe_checkout_success_url+'?session_id={CHECKOUT_SESSION_ID}'),
      cancel_url: shop_stripe_checkout_cancel_url, # optional
      # payment_method_types: [shop_order.payment_method], # optional (Stripe uses all enabled methods when commented)
      customer_email: shop_order.email, # optional (pre-fills email field on the stripe site)
      metadata: { order_id: shop_order.id }, # optional (used to find shop_order in the webhook)
      client_reference_id: current_user.id, # optional
      # {stripe_account: '{{CONNECTED_ACCOUNT_ID}}'}, # optional (for branding?)
    })
    # Redirect to the Stripe URL
    redirect_to checkout_session.url, allow_other_host: true

    # account = Stripe::Account.create
    # { account: account[:id] }.to_json # response

    # # Transfer a specific amount to a given destination (e.g. a seller account) and only leave my platform fee
    # amount_for_seller = total_price * (1.0 - 0.05) # 5% left for me (95% goes to the seller)
    # transfer = Stripe::Transfer.create({
    #   amount: (amount_for_seller * 100).to_i, # price in Rp
    #   currency: 'chf',
    #   destination: 'acct_1Pc88NJFjCRueizw', # seller account blup: swisssmash.ch
    #   transfer_group: "ORDER_#{shop_order.id}",
    #   metadata: { order_id: shop_order.id } # optional
    # })
  end

  # GET /shop/stripe/success?session_id=...
  def success
    # checkout_session = Stripe::Checkout::Session.retrieve(params[:session_id])
    # shop_order = ShopOrder.find(checkout_session.metadata.order_id)
    # shop_order.complete! -> is handled in the webhook
    redirect_to shop_orders_path, notice: t('flash.shop_order_created')
  end

  # GET /shop/stripe/cancel
  def cancel
    redirect_to shop_checkout_path
  end

end