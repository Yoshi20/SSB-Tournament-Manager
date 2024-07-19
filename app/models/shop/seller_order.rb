class Shop::SellerOrder < ApplicationRecord
  self.table_name = "shop_seller_orders"

  belongs_to :user
  belongs_to :order, class_name: 'Shop::Order'

  after_validation :set_order_sent_at, on: [ :update ]
  after_validation :set_status, on: [ :update ]

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

  def purchases
    self.order.shopping_cart.purchases.where(stripe_account_id: self.stripe_account_id)
  end

  def total_price
    total_price = 0
    self.purchases.includes(:product).each do |purchase|
      total_price = total_price + (purchase.product.price * purchase.quantity)
    end
    total_price = total_price + self.shipping_costs
    return total_price
  end

  def total_price_text(price = nil)
    total_price = price.present? ? price.round(1) : self.total_price.round(1)
    delimeter = self.currency == 'chf' ? '.' : ','
    return (total_price%1 == 0) ? "#{total_price.to_i}#{delimeter}-" : "#{total_price}0"
  end

  def shipping_costs
    shipping = 0
    self.purchases.includes(:product).each do |purchase|
      shipping = [purchase.product.shipping, shipping].max if purchase.quantity > 0
    end
    return shipping
  end

  def currency
    self.purchases.first.product.currency
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

end
