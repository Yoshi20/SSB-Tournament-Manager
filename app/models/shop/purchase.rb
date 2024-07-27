class Shop::Purchase < ApplicationRecord
  self.table_name = "shop_purchases"

  belongs_to :product, class_name: 'Shop::Product'
  belongs_to :shopping_cart, class_name: 'Shop::ShoppingCart'

  validates :quantity, presence: true
  validates :quantity, :numericality => { greater_than_or_equal_to: 0 }

  def limit_quantity
    return false unless self.product.subtype == 'physical'
    max_quantity = self.product.stock.to_i
    was_limitted = false
    if self.quantity.to_i > max_quantity
      self.quantity = max_quantity
      was_limitted = true
    end
    return was_limitted
  end

  def product_name
    self.product.name + (self.variant.present? ? " (#{self.variant})" : "")
  end

  def currency
    self.product.currency
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

end
