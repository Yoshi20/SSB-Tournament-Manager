class ShopSellerOrder < ApplicationRecord
  belongs_to :shop_order
  belongs_to :user

  after_validation :set_order_sent_at, on: [ :update ]
  after_validation :set_status, on: [ :update ]

  def set_order_sent_at
    self.order_sent_at = self.was_order_sent ? DateTime.now : nil
  end

  def set_status
    if self.was_order_sent
      self.status = 'sent'
    else
      self.status = self.shop_order.status
    end
  end

  def recently_updated?
    self.updated_at >= 3.seconds.ago
  end

  def status_text
    if self.was_order_sent
      I18n.t('shop_orders.status.sent') + " (#{self.order_sent_at.localtime.to_fs(:custom_datetime_date)})"
    else
      self.shop_order.status_text
    end
  end

  def purchases
    self.shop_order.shopping_cart.shop_purchases.where(stripe_account_id: self.stripe_account_id)
  end

  def total_price
    total_price = 0
    self.purchases.includes(:shop_product).each do |purchase|
      total_price = total_price + (purchase.shop_product.price * purchase.quantity)
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
    self.purchases.includes(:shop_product).each do |purchase|
      shipping = [purchase.shop_product.shipping, shipping].max if purchase.quantity > 0
    end
    return shipping
  end

  def currency
    self.purchases.first.shop_product.currency
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

end
