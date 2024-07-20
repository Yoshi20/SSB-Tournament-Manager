class Shop::Product < ApplicationRecord
  self.table_name = "shop_products"

  include PositionHandler

  belongs_to :user
  has_many :purchases, class_name: 'Shop::Purchase', dependent: :destroy

  validates :name, presence: true
  validates :currency, presence: true
  validates :price, presence: true
  validates :stock, presence: true
  validates :stock, :numericality => { greater_than_or_equal_to: 0 }
  validates :shipping, presence: true

  after_validation :set_position, on: [ :create ]

  HIGH_STOCK_QUANTITY = 10
  LOW_STOCK_QUANTITY = 3

  def set_position
    products = Shop::Product.all.order(:position, :created_at)
    self.position = (products.any? ? (products.last.position.to_i+1) : 0)
  end

  def seller_name
    self.user&.player&.gamer_tag
  end

  def price_short(quantity = 1)
    price = (self.price * quantity).round(1)
    delimeter = self.currency == 'chf' ? '.' : ','
    (price%1 == 0) ? "#{price.to_i}#{delimeter}-" : "#{price}0"
  end

  def price_long(quantity = 1)
    price = (self.price * quantity).round(1)
    delimeter = self.currency == 'chf' ? '.' : ','
    (price%1 == 0) ? "#{price.to_i}#{delimeter}00" : "#{price}0"
  end

  def stock_text
    if self.stock > HIGH_STOCK_QUANTITY
      I18n.t('shop.products.stock_text.high', stock: HIGH_STOCK_QUANTITY)
    elsif self.stock > LOW_STOCK_QUANTITY
      I18n.t('shop.products.stock_text.normal', stock: self.stock)
    elsif self.stock > 0
      I18n.t('shop.products.stock_text.low', stock: self.stock)
    else
      I18n.t('shop.products.stock_text.zero')
    end
  end

  def stock_text_color
    if self.stock > LOW_STOCK_QUANTITY
      'green'
    elsif self.stock > 0
      'orange'
    else
      'red'
    end
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

end
