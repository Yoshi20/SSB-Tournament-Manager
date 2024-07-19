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
      self.status = self.order.status
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

end
