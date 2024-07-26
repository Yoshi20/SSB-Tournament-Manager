class Shop::SellerOrder < ApplicationRecord
  self.table_name = "shop_seller_orders"

  belongs_to :user
  belongs_to :order, class_name: 'Shop::Order'

  after_validation :set_sold_products_and_more, on: [ :create ]
  after_validation :set_order_sent_at, on: [ :update ]
  after_validation :set_status, on: [ :update ]

  def set_sold_products_and_more
    shopping_cart = self.order.shopping_cart
    country_code = shopping_cart.country_code
    purchases = shopping_cart.purchases.where(stripe_account_id: self.stripe_account_id).includes(:product)
    sold_products = []
    shipping = 0
    total_price = 0
    purchases.each do |purchase|
      product = purchase.product
      sold_products << {
        name: purchase.product_name,
        description: product.description,
        currency: product.currency,
        price: product.price,
        shipping: product.shipping(country_code),
        quantity: purchase.quantity,
        product_id: product.id,
        subtype: product.subtype,
      }
      if purchase.quantity > 0
        number_of_packages = (purchase.quantity.to_f / product.max_quantity_per_package).round
        shipping = [product.shipping(country_code)*number_of_packages, shipping].max
      end
      total_price += (purchase.product.price * purchase.quantity)
    end
    total_price += shipping
    self.sold_products_json = sold_products
    self.currency = purchases.first.product.currency
    self.shipping_costs = shipping
    self.total_price = total_price
    number_of_sellers = shopping_cart.purchases.pluck(&:stripe_account_id).uniq.count
    self.total_fee = total_price * Shop::Order::FeeInPercent + Shop::Order::FeeFlatrate/number_of_sellers
  end

  def set_order_sent_at
    self.order_sent_at = self.was_order_sent ? DateTime.now : nil
  end

  def set_status
    if self.was_order_sent
      self.status = 'sent'
    else
      self.status = self.order.status
    end
  end

  def recently_updated?
    self.updated_at >= 3.seconds.ago
  end

  def status_text
    if self.was_order_sent
      I18n.t('shop.orders.status.sent') + " (#{self.order_sent_at.localtime.to_fs(:custom_datetime_date)})"
    else
      self.order.status_text
    end
  end

  def total_price_text(price = nil)
    total_price = price.present? ? price.round(1) : self.total_price.round(1)
    delimeter = self.currency == 'chf' ? '.' : ','
    return (total_price%1 == 0) ? "#{total_price.to_i}#{delimeter}-" : "#{total_price}0"
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

end
