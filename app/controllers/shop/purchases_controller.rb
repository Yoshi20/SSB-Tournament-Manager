class Shop::PurchasesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_shop_purchase, only: %i[ update destroy ]
  before_action { @section = 'shop' }

  # POST /shop/purchases or /shop/purchases.json
  def create
    @shopping_cart = Shop::ShoppingCart.find_or_create_latest(request.remote_ip, current_user&.id, session['session_id'], session['country_code'])
    # only update quantity if a purchase with the same product already exists
    @shop_purchase = @shopping_cart.purchases.find_by(product_id: shop_purchase_params[:product_id], variant: shop_purchase_params[:variant])
    if @shop_purchase.present?
      @shop_purchase.quantity = @shop_purchase.quantity + 1
    else
      @shop_purchase = Shop::Purchase.new(shop_purchase_params)
      @shop_purchase.shopping_cart_id = @shopping_cart.id
      @shop_purchase.quantity = 1
      @shop_purchase.stripe_account_id = @shop_purchase.product.user.stripe_account_id
    end
    was_limitted = @shop_purchase.limit_quantity
    is_same_currency = (@shopping_cart.currency.nil? || @shopping_cart.currency == @shop_purchase.currency)
    respond_to do |format|
      if (!was_limitted && is_same_currency) && @shop_purchase.save
        @shopping_cart.update(currency: @shop_purchase.currency) unless @shopping_cart.currency.present?
        format.html { redirect_to shop_path, notice: t('flash.shop_purchase_created') }
        format.json { render :show, status: :created, location: @shop_purchase }
      else
        format.html { redirect_to shop_path, alert: (is_same_currency ? t('flash.shop_purchase_not_created_limit') : t('flash.shop_purchase_not_created_currency', currency: @shopping_cart.currency_text)) }
        format.json { render json: @shop_purchase.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /shop/purchases/1 or /shop/purchases/1.json
  def update
    @shop_purchase.assign_attributes(shop_purchase_params)
    was_limitted = @shop_purchase.limit_quantity
    respond_to do |format|
      if @shop_purchase.quantity >= 0 && @shop_purchase.save
        format.html {
          if was_limitted
            redirect_to shop_shopping_cart_path, flash: {warn: t('flash.shop_purchase_limitted')}
          else
            redirect_to shop_shopping_cart_path, notice: t('flash.shop_purchase_updated')
          end
        }
        format.json { render :show, status: :ok, location: @shop_purchase }
      else
        format.html { redirect_to shop_shopping_cart_path, alert: t('flash.shop_purchase_not_updated') }
        format.json { render json: @shop_purchase.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /shop/purchases/1 or /shop/purchases/1.json
  def destroy
    shopping_cart = @shop_purchase.shopping_cart
    @shop_purchase.destroy
    respond_to do |format|
      format.html {
        # redirect to the shop if no purchases are left
        if shopping_cart.purchases.any?
          redirect_to shop_shopping_cart_path, notice: t('flash.shop_purchase_deleted')
        else
          shopping_cart.destroy
          redirect_to shop_path, notice: t('flash.shop_purchase_deleted')
        end
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop_purchase
      @shop_purchase = Shop::Purchase.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_purchase_params
      params.require(:shop_purchase).permit(:quantity, :product_id, :variant)
    end

end
