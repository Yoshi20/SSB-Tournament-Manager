class Shop::Product < ApplicationRecord
  self.table_name = "shop_products"

  include PositionHandler

  belongs_to :user
  has_many :purchases, class_name: 'Shop::Purchase', dependent: :destroy

  validates :name, presence: true
  validates :currency, presence: true
  validates :price, presence: true
  validates :price, :numericality => { greater_than_or_equal_to: 1 }
  validates :stock, presence: true
  validates :stock, :numericality => { greater_than_or_equal_to: 0 }
  validates :shipping_national, presence: true
  validates :shipping_international, presence: true
  validates :shipping_international_eu, presence: true
  validates :max_quantity_per_package, presence: true
  validates :max_quantity_per_package, :numericality => { greater_than_or_equal_to: 1 }

  after_validation :handle_subtype, on: [ :create, :update ]
  after_validation :set_position, on: [ :create ]

  MAX_LEN_DESCRIPTION_SHORT = 100
  HIGH_STOCK_QUANTITY = 10
  LOW_STOCK_QUANTITY = 3

  def handle_subtype
    unless self.subtype == 'physical'
      self.shipping_national = 0
      self.shipping_international = 0
      self.shipping_international_eu = 0
      self.stock = 0
      self.max_quantity_per_package = 1
    end
  end

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

  def shipping(country_code)
    eu_countries = ['at', 'be', 'bg', 'hr', 'cy', 'dk', 'ee', 'fi', 'fr', 'de', 'gr', 'hu', 'ie', 'it', 'lv', 'lt', 'lu', 'mt', 'nl', 'pl', 'pt', 'ro', 'sk', 'si', 'es', 'se']
    if country_code == self.country_code
      self.shipping_national
    elsif country_code.in?(eu_countries)
      self.shipping_international_eu
    else
      self.shipping_international
    end
  end

  def stock_text
    if self.subtype == 'service'
      I18n.t('shop.products.subtypes.service')
    elsif self.subtype == 'digital'
      I18n.t('shop.products.subtypes.digital')
    elsif self.subtype == 'physical'
      if self.stock > HIGH_STOCK_QUANTITY
        I18n.t('shop.products.stock_text.high', stock: HIGH_STOCK_QUANTITY)
      elsif self.stock > LOW_STOCK_QUANTITY
        I18n.t('shop.products.stock_text.normal', stock: self.stock)
      elsif self.stock > 0
        I18n.t('shop.products.stock_text.low', stock: self.stock)
      else
        I18n.t('shop.products.stock_text.zero')
      end
    else
      I18n.t('shop.products.stock_text.zero')
    end
  end

  def stock_text_color
    if self.subtype == 'service'
      'green'
    elsif self.subtype == 'digital'
      'green'
    elsif self.subtype == 'physical'
      if self.stock > LOW_STOCK_QUANTITY
        'green'
      elsif self.stock > 0
        'orange'
      else
        'red'
      end
    else
      'red'
    end
  end

  def currency_text
    Currency::hash[self.currency.to_sym]
  end

  def variants_array
    self.variants.present? ? self.variants.split(',').compact.collect(&:strip) : []
  end

end
