class ShoppingCart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :shop_purchases, dependent: :destroy
  has_many :shop_orders, dependent: :destroy

  scope :active, -> { where(has_checked_out: false) }

  def self.find_latest(client_ip, user_id, session_id)
    cart = nil
    # try to find latest open shopping cart using user_id, session_id or client_ip (in this order)
    scope = ShoppingCart.active.order(:created_at)
    cart = scope.where(user_id: user_id).last if user_id.present?
    cart = scope.where(session_id: session_id).last if cart.nil? && session_id.present?
    cart = scope.where(client_ip: client_ip).last if cart.nil? && client_ip.present?
    # if shopping cart was found -> update the client params
    if cart.present?
      cart.user_id = user_id if user_id.present?
      cart.client_ip = client_ip if client_ip.present?
      cart.session_id = session_id if session_id.present?
      cart.save
    end
    return cart
  end

  def self.find_or_create_latest(client_ip, user_id, session_id)
    cart = self.find_latest(client_ip, user_id, session_id)
    # if no shopping cart was found -> create a new one
    unless cart.present?
      cart = ShoppingCart.create(client_ip: client_ip, user_id: user_id, session_id: session_id)
    end
    return cart
  end

  def username
    self.user&.username
  end

  def currency
    self.shop_purchases.first&.currency
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

  def purchases_group_by_stripe_account_ids
    self.shop_purchases.includes(:shop_product).group_by(&:stripe_account_id)
  end

  def shipping_costs
    shipping = 0
    # add max shipping for each seller (not only the max from all products)
    self.purchases_group_by_stripe_account_ids.each do |acct_purchase|
      acct_shipping = 0
      acct_purchase[1].each do |purchase|
        acct_shipping = [purchase.shop_product.shipping, shipping].max if purchase.quantity > 0
      end
      shipping += acct_shipping
    end
    return shipping
  end

  def shipping_costs_text
    shipping_costs = self.shipping_costs.round(1)
    return (shipping_costs%1 == 0) ? "#{shipping_costs.to_i}.00" : "#{shipping_costs}0"
  end

  def total_price
    total_price = 0
    self.shop_purchases.includes(:shop_product).each do |purchase|
      total_price = total_price + (purchase.shop_product.price * purchase.quantity)
    end
    total_price = total_price + self.shipping_costs
    return total_price
  end

  def total_price_text(price = nil)
    total_price = price.present? ? price.round(1) : self.total_price.round(1)
    return (total_price%1 == 0) ? "#{total_price.to_i}.-" : "#{total_price}0"
  end

  def total_price_text_long(price = nil)
    total_price = price.present? ? price.round(1) : self.total_price.round(1)
    return (total_price%1 == 0) ? "#{total_price.to_i}.00" : "#{total_price}0"
  end

  def checkout!
    if self.has_checked_out == false
      self.update!(has_checked_out: true)
      self.shop_purchases.includes(:shop_product).each do |purchase|
        product = purchase.shop_product
        product.update!(stock: product.stock - purchase.quantity)
      end
    end
  end

  def revert_checkout!
    if self.has_checked_out == true
      self.shop_purchases.includes(:shop_product).each do |purchase|
        product = purchase.shop_product
        product.update!(stock: product.stock + purchase.quantity)
      end
      self.update!(has_checked_out: false)
    end
  end

end
