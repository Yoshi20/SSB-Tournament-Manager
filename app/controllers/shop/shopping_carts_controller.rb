class Shop::ShoppingCartsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_super_admin!, only: %i[ destroy ]
  before_action :set_shopping_cart, only: %i[ show ]
  before_action { @section = 'shop' }

  # GET /shopping_cart
  def show
    # @purchases_and_quantities = @shopping_cart.shop_purchases.includes(:shop_product).group_by(&:shop_product_id).map{ |sp| [sp[1][0], sp[1].sum(&:quantity)] }
    if @shopping_cart.present?
      @purchases = @shopping_cart.shop_purchases.includes(:shop_product).order(:created_at)
      unless @purchases.any?
        @shopping_cart.destroy
        redirect_to shop_path
      end
    else
      redirect_to shop_path
    end
  end

  # DELETE /shopping_cart/1
  def destroy
    @shopping_cart = ShoppingCart.find(params[:id])
    @shopping_cart.revert_checkout!
    @shopping_cart.destroy
    respond_to do |format|
      format.html { redirect_to shop_orders_path, notice: t('flash.shopping_cart_deleted') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart
      @shopping_cart = ShoppingCart.find_latest(request.remote_ip, current_user&.id, session['session_id'])
    end

end
