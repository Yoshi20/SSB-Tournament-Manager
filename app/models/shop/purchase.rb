class Shop::Purchase < ApplicationRecord
  self.table_name = "shop_purchases"

  belongs_to :product, class_name: 'Shop::Product'
  belongs_to :shopping_cart, class_name: 'Shop::ShoppingCart'

  validates :quantity, presence: true
  validates :quantity, :numericality => { greater_than_or_equal_to: 0 }

  def limit_quantity
    max_quantity = self.product.stock
    was_limitted = false
    if self.quantity > max_quantity
      self.quantity = max_quantity
      was_limitted = true
    end
    return was_limitted
  end

  def currency
    self.product.currency
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

end
