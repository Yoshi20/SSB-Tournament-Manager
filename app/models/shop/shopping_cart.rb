class Shop::ShoppingCart < ApplicationRecord
  self.table_name = "shopping_carts"

  belongs_to :user, optional: true
  has_many :purchases, class_name: 'Shop::Purchase', dependent: :destroy
  has_many :orders, class_name: 'Shop::Order', dependent: :destroy

  scope :active, -> { where(has_checked_out: false) }

  def self.find_latest(client_ip, user_id, session_id)
    cart = nil
    # try to find latest open shopping cart using user_id, session_id or client_ip (in this order)
    scope = Shop::ShoppingCart.active.order(:created_at)
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

  def self.find_or_create_latest(client_ip, user_id, session_id, country_code)
    cart = self.find_latest(client_ip, user_id, session_id)
    # if no shopping cart was found -> create a new one
    unless cart.present?
      cart = Shop::ShoppingCart.create(client_ip: client_ip, user_id: user_id, session_id: session_id, country_code: country_code)
    end
    return cart
  end

  def username
    self.user&.username
  end

  def currency
    self.purchases.first&.currency
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

  def shipping_costs
    shipping = 0
    # add max shipping for each seller (not only the max from all products)
    self.purchases.includes(:product).group_by(&:stripe_account_id).each do |acct_purchase|
      acct_shipping = 0
      acct_purchase[1].each do |purchase|
        acct_shipping = [purchase.product.shipping(self.country_code), acct_shipping].max if purchase.quantity > 0
      end
      shipping += acct_shipping
    end
    return shipping
  end

  def shipping_costs_text
    shipping_costs = self.shipping_costs.round(1)
    delimeter = self.currency == 'chf' ? '.' : ','
    return (shipping_costs%1 == 0) ? "#{shipping_costs.to_i}#{delimeter}00" : "#{shipping_costs}0"
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

  def total_price_text_long(price = nil)
    total_price = price.present? ? price.round(1) : self.total_price.round(1)
    delimeter = self.currency == 'chf' ? '.' : ','
    return (total_price%1 == 0) ? "#{total_price.to_i}#{delimeter}00" : "#{total_price}0"
  end

  def checkout!
    if self.has_checked_out == false
      self.update!(has_checked_out: true)
      self.purchases.includes(:product).each do |purchase|
        product = purchase.product
        product.update!(stock: product.stock - purchase.quantity)
      end
    end
  end

  def revert_checkout!
    if self.has_checked_out == true
      self.purchases.includes(:product).each do |purchase|
        product = purchase.product
        product.update!(stock: product.stock + purchase.quantity)
      end
      self.update!(has_checked_out: false)
    end
  end

end
