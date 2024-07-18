class ShopPurchase < ApplicationRecord
  belongs_to :shop_product
  belongs_to :shopping_cart

  validates :quantity, presence: true
  validates :quantity, :numericality => { greater_than_or_equal_to: 0 }

  def limit_quantity
    max_quantity = self.shop_product.stock
    was_limitted = false
    if self.quantity > max_quantity
      self.quantity = max_quantity
      was_limitted = true
    end
    return was_limitted
  end

  def currency
    self.shop_product.currency
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

end
