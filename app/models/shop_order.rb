class ShopOrder < ApplicationRecord
  belongs_to :shopping_cart

  validates :email, presence: true

  before_validation :strip_whitespace
  after_validation :set_order_paid_at, on: [ :update ]
  after_validation :set_order_sent_at, on: [ :update ]
  after_validation :set_status, on: [ :update ]

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
    self.order_paid_at = self.was_order_paid ? DateTime.now : nil
  end

  def set_order_sent_at
    self.order_sent_at = self.was_order_sent ? DateTime.now : nil
  end

  def set_status
    if self.was_order_sent
      self.status = 'sent'
    elsif self.was_order_paid
      self.status = 'paid'
    else
      self.status = 'open'
    end
  end

  def recently_updated?
    self.updated_at >= 3.seconds.ago
  end

  def complete!(current_app_mode)
    self.shopping_cart.checkout!
    ShopMailer.with(shop_order: self, app_mode: current_app_mode).order_created_email.deliver_later
    ShopMailer.with(email: self.email, app_mode: current_app_mode).thank_you_email.deliver_later
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
    if self.was_order_sent
      I18n.t('shop_orders.status.sent') + " (#{self.order_sent_at.localtime.to_fs(:custom_datetime_date)})"
    elsif self.was_order_paid
      I18n.t('shop_orders.status.paid') + " (#{self.order_paid_at.localtime.to_fs(:custom_datetime_date)})"
    else
      I18n.t("shop_orders.status.#{self.status}")
    end
  end

end