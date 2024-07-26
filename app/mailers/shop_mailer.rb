class ShopMailer < ApplicationMailer

  def new_product_email
    @shop_product = params[:shop_product]
    country_code = @shop_product.country_code
    @url = shop_url(country_code)
    @domain = Domain.domain_from(country_code)
    mail(
      from: Domain.email_from(country_code),
      to: Domain.email_from(country_code),
      subject: "New shop product on #{@domain}!",
      delivery_method_options: Domain.delivery_options_from(country_code)
    )
  end

  def order_paid_email
    shop_order = params[:shop_order]
    country_code = params[:country_code]
    @url = shop_orders_url(country_code, shop_order.id)
    @domain = Domain.domain_from(country_code)
    mail(
      from: Domain.email_from(country_code),
      to: Domain.email_from(country_code),
      subject: "New shop order on #{@domain}!",
      delivery_method_options: Domain.delivery_options_from(country_code)
    )
  end

  def seller_order_paid_email
    seller_order = params[:seller_order]
    country_code = params[:country_code]
    @url = seller_orders_url(country_code, seller_order.id)
    @domain = Domain.domain_from(country_code)
    mail(
      from: Domain.email_from(country_code),
      to: seller_order.user.email,
      bcc: Domain.email_from(country_code),
      subject: "You've sold something on #{@domain}!",
      delivery_method_options: Domain.delivery_options_from(country_code)
    )
  end

  def thank_you_email
    @shop_order = params[:shop_order]
    country_code = params[:country_code]
    @domain = Domain.domain_from(country_code)
    @title = Domain.title_from(country_code)
    seller_emails = @shop_order.seller_orders.map{ |so| so.user.email}
    # I18n.with_locale(Domain.default_locale_from(@user.country_code)) do
    mail(
      from: Domain.email_from(country_code),
      to: @shop_order.email,
      bcc: [Domain.email_from(country_code)] + seller_emails,
      subject: t('shop_mailer.thank_you_email.subject', title: @title),
      delivery_method_options: Domain.delivery_options_from(country_code)
    )
    # end
  end

  private

  def shop_orders_url(country_code, path)
    "https://www.#{Domain.domain_from(country_code)}/shop/orders/#{path}"
  end

  def seller_orders_url(country_code, path)
    "https://www.#{Domain.domain_from(country_code)}/shop/seller_orders/#{path}"
  end

  def shop_url(country_code)
    "https://www.#{Domain.domain_from(country_code)}/shop"
  end

end
