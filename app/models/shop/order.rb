class Shop::Order < ApplicationRecord
  self.table_name = "shop_orders"

  belongs_to :shopping_cart, class_name: 'Shop::ShoppingCart'
  has_many :seller_orders, class_name: 'Shop::SellerOrder', dependent: :destroy

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :strip_whitespace
  after_validation :set_order_paid_at, on: [ :update ]
  after_validation :set_status, on: [ :update ]
  after_create :find_real_country_code
  after_create :create_seller_orders

  FeeInPercent = (0.0325 + 0.05) # Stripe-Fee: 3.25% + 0.3 + Platform-Fee: 5%
  FeeFlatrate = 0.3 # Stripe-Fee: 3.25% + 0.3

  def strip_whitespace
    self.organisation.try(:strip!)
    self.name.try(:strip!)
    self.address.try(:strip!)
    self.address2.try(:strip!)
    self.zip_code.try(:strip!)
    self.city.try(:strip!)
    self.phone_number.try(:strip!)
    self.email.try(:strip!)
  end

  def set_order_paid_at
    self.order_paid_at = self.was_order_paid ? Time.zone.now : nil
  end

  def set_status
    if self.was_order_paid
      self.status = 'paid'
    else
      self.status = 'open'
    end
  end

  # Try to find real_country_code from address if present (to prevent fake shipping costs)
  def find_real_country_code
    return unless self.address.present? || self.city.present?
    real_country_code = Request.find_country_code(self.complete_address)
    # update shopping_cart.country_code if we found a fake one
    if real_country_code.present? && (real_country_code != self.shopping_cart.country_code)
      self.shopping_cart.update(country_code: real_country_code)
    end
  end

  def create_seller_orders
    stripe_account_ids = Shop::Purchase.where(shopping_cart_id: self.shopping_cart_id).pluck(:stripe_account_id)
    stripe_account_ids.uniq!
    stripe_account_ids.each do |acct|
      user = User.find_by(stripe_account_id: acct)
      Shop::SellerOrder.create(
        order_id: self.id,
        user_id: user.id,
        status: self.status,
        stripe_account_id: user.stripe_account_id, # in case user changes stripe_account_id later
      )
    end
  end

  def recently_updated?
    self.updated_at >= 3.seconds.ago
  end

  def has_physicals?
    self.shopping_cart.has_physicals?
  end

  def complete!
    self.shopping_cart.checkout!
    country_code = self.shopping_cart.country_code
    ShopMailer.with(shop_order: self, country_code: country_code).order_paid_email.deliver_later
    ShopMailer.with(shop_order: self, country_code: country_code).thank_you_email.deliver_later
    self.seller_orders.each do |seller_order|
      ShopMailer.with(seller_order: seller_order, country_code: country_code).seller_order_paid_email.deliver_later
    end
  end

  def revert_checkout
    ok = true
    begin
      ActiveRecord::Base.transaction do
        self.shopping_cart.revert_checkout!
      end
    rescue # must be outside of Base.transaction to make sure everything is rolled back
      ok = false
    end
    return ok
  end

  def complete_address
    str = ""
    str = str + "#{self.organisation}\n" if self.organisation.present?
    str = str + "#{self.name}\n" if self.name.present?
    str = str + "#{self.address}\n" if self.address.present?
    str = str + "#{self.address2}\n" if self.address2.present?
    str = str + "#{self.zip_code} #{self.city}".strip if self.zip_code.present? || self.city.present?
    return str
  end

  def status_text
    if self.was_order_paid
      I18n.t('shop.orders.status.paid') + " (#{self.order_paid_at.localtime.to_fs(:custom_datetime_date)})"
    else
      I18n.t("shop.orders.status.#{self.status}")
    end
  end

end
