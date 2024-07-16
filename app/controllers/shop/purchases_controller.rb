class Shop::PurchasesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_shop_purchase, only: %i[ update destroy ]
  before_action { @section = 'shop' }

  # POST /shop_purchases or /shop_purchases.json
  def create
    @shopping_cart = ShoppingCart.find_or_create_latest(request.remote_ip, current_user&.id, session['session_id'])
    # only update quantity if a purchase with the same product already exists
    @shop_purchase = @shopping_cart.shop_purchases.find_by(shop_product_id: shop_purchase_params[:shop_product_id])
    if @shop_purchase.present?
      @shop_purchase.quantity = @shop_purchase.quantity + 1
    else
      @shop_purchase = ShopPurchase.new(shop_purchase_params)
      @shop_purchase.shopping_cart_id = @shopping_cart.id
      @shop_purchase.quantity = 1
    end
    was_limitted = @shop_purchase.limit_quantity
    respond_to do |format|
      if !was_limitted && @shop_purchase.save
        format.html { redirect_to shop_path, notice: t('flash.shop_purchase_created') }
        format.json { render :show, status: :created, location: @shop_purchase }
      else
        format.html { redirect_to shop_path, alert: t('flash.shop_purchase_not_created') }
        format.json { render json: @shop_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shop_purchases/1 or /shop_purchases/1.json
  def update
    respond_to do |format|
      edited_shop_purchase_params = shop_purchase_params.dup
      quantity = edited_shop_purchase_params[:quantity].to_i
      max_quantity = @shop_purchase.shop_product.stock
      was_limitted = false
      if quantity > max_quantity
        edited_shop_purchase_params[:quantity] = max_quantity
        was_limitted = true
      end
      if quantity >= 0 && @shop_purchase.update(edited_shop_purchase_params)
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
        format.json { render json: @shop_purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shop_purchases/1 or /shop_purchases/1.json
  def destroy
    shopping_cart = @shop_purchase.shopping_cart
    @shop_purchase.destroy
    respond_to do |format|
      format.html {
        # redirect to the shop if no purchases are left
        if shopping_cart.shop_purchases.any?
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
      @shop_purchase = ShopPurchase.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_purchase_params
      params.require(:shop_purchase).permit(:quantity, :shop_product_id)
    end

end
