class Shop::ShoppingCartsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :authenticate_super_admin!, only: %i[ destroy ]
  before_action :set_shopping_cart, only: %i[ show ]
  before_action { @section = 'shop' }

  # GET /shopping_cart
  def show
    if @shopping_cart.present?
      @purchases = @shopping_cart.purchases.includes(:product).order(:created_at)
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
    @shopping_cart = Shop::ShoppingCart.find(params[:id])
    @shopping_cart.revert_checkout!
    @shopping_cart.destroy
    respond_to do |format|
      format.html { redirect_to shop_orders_path, notice: t('flash.shop_shopping_cart_deleted') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shopping_cart
      @shopping_cart = Shop::ShoppingCart.find_latest(request.remote_ip, current_user&.id, session['session_id'])
    end

end
