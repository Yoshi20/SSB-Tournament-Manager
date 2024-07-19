class Shop::Stripe::CheckoutsController < Shop::Stripe::StripeController

  # GET /shop/stripe/checkout?order_id=1
  def checkout
    shop_order = ShopOrder.find(params[:order_id])
    shopping_cart = shop_order.shopping_cart
    if (shop_order.was_order_paid || shopping_cart.has_checked_out)
      redirect_to shop_stripe_checkout_cancel_path
      return
    end
    currency = shopping_cart.currency
    line_items = []
    transfer_data = []
    # purchases
    shopping_cart.shop_purchases.includes(:shop_product).order(:created_at).each do |purchase|
      next if purchase.quantity <= 0
      product = purchase.shop_product
      # populate line_items
      line_items << {
        price_data: {
          currency: product.currency,
          product_data: {name: product.name},
          unit_amount: (product.price * 100).to_i, # price in Rp
        },
        quantity: purchase.quantity,
      }
      # populate transfer_data (either add to existing or create new entry)
      td = transfer_data.find{ |td| td[:stripe_account_id] == purchase.stripe_account_id }
      if td.present?
        td[:price] += (product.price * purchase.quantity)
        td[:shipping] += product.shipping
      else
        transfer_data << {
          stripe_account_id: purchase.stripe_account_id,
          currency: product.currency,
          price: (product.price * purchase.quantity),
          shipping: product.shipping,
        }
      end
    end
    shipping = shopping_cart.shipping_costs
    # # shipping (could also be handled in Stripe::Checkout::Session)
    # if shipping > 0
    #   line_items << {
    #     price_data: {
    #       currency: currency,
    #       product_data: {name: t('shopping_cart.shipment')},
    #       unit_amount: (shipping * 100).to_i, # price in Rp
    #     },
    #     quantity: 1,
    #   }
    # end
    # # stripe fee (only add this if you want the user to pay it)
    # total_price = shopping_cart.total_price
    # stripe_fees = total_price * 0.03 + 0.5 # 3% + 0.5 CHF
    # line_items << {
    #   price_data: {
    #     currency: currency,
    #     product_data: {name: t('shopping_cart.stripe_fees')},
    #     unit_amount: (stripe_fees * 100).to_i, # price in Rp
    #   },
    #   quantity: 1,
    # }
    # Stripe checkout session request
    checkout_session = Stripe::Checkout::Session.create({
      line_items: line_items,
      payment_intent_data: {
        # on_behalf_of: '{{CONNECTED_ACCOUNT_ID}}',
        transfer_group: "ORDER_#{shop_order.id}",
        # application_fee_amount: 123, # https://docs.stripe.com/connect/collect-then-transfer-guide?locale=de-DE&connect-account-creation-pattern=typeless
        # transfer_data: {destination: '{{CONNECTED_ACCOUNT_ID}}' },
      },
      mode: 'payment',
      success_url: (shop_stripe_checkout_success_url+'?session_id={CHECKOUT_SESSION_ID}'),
      cancel_url: shop_stripe_checkout_cancel_url, # optional
      # payment_method_types: [shop_order.payment_method], # optional (Stripe uses all enabled methods when commented)
      customer_email: shop_order.email, # optional (pre-fills email field on the stripe site)
      metadata: { # optional
        order_id: shop_order.id, # used to find shop_order in the webhook
        transfer_data_json: transfer_data.to_json, # used to handle transfers in the webhook
      },
      # client_reference_id: current_user.id, # optional
      # {stripe_account: '{{CONNECTED_ACCOUNT_ID}}'}, # optional (for branding?)
      shipping_options: (shipping > 0 ? [{
        shipping_rate_data: {
          display_name: I18n.t('shopping_cart.shipment'), #blup: paket national or international text?
          type: 'fixed_amount',
          fixed_amount: {
            amount: (shipping * 100).to_i, # price in Rp
            currency: currency,
          },
        },
      }] : nil),
    })
    # Redirect to the Stripe URL
    redirect_to checkout_session.url, allow_other_host: true
  end

  # GET /shop/stripe/checkout_success?session_id=...
  def success
    # checkout_session = Stripe::Checkout::Session.retrieve(params[:session_id])
    # shop_order = ShopOrder.find(checkout_session.metadata.order_id)
    # shop_order.complete! -> is handled in the webhook
    # transfer_data_array = JSON.parse(checkout_session.metadata.transfer_data_json)
    redirect_to shop_orders_path, notice: t('flash.shop_order_created')
  end

  # GET /shop/stripe/checkout_cancel
  def cancel
    redirect_to shop_checkout_path
  end

end
