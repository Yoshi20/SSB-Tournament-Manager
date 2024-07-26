# Preview all emails at http://localhost:3000/rails/mailers/shop_mailer
class ShopMailerPreview < ActionMailer::Preview
  def new_product_email
    shop_product = Shop::Product.last
    country_code = shop_product.country_code
    ShopMailer.with(shop_product: shop_product).new_product_email
  end

  def order_paid_email
    shop_order = Shop::Order.last
    country_code = shop_order.shopping_cart.country_code
    ShopMailer.with(shop_order: shop_order, country_code: country_code).order_paid_email
  end

  def seller_order_paid_email
    seller_order = Shop::SellerOrder.last
    country_code = seller_order.order.shopping_cart.country_code
    ShopMailer.with(seller_order: seller_order, country_code: country_code).seller_order_paid_email
  end

  def thank_you_email
    shop_order = Shop::Order.last
    country_code = shop_order.shopping_cart.country_code
    ShopMailer.with(shop_order: shop_order, country_code: country_code).thank_you_email
  end

end
