class Shop::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_seller!, only: [:new, :create]
  before_action :set_shop_product, only: %i[ edit update destroy move_down ]
  before_action :authenticate_product_creator!, only: [:edit, :update, :destroy]
  before_action { @section = 'shop' }

  # GET /shop/products/new
  def new
    @shop_product = Shop::Product.new
  end

  # GET /shop/products/1/edit
  def edit
  end

  # POST /shop/products or /shop/products.json
  def create
    @shop_product = Shop::Product.new(shop_product_params)
    @shop_product.user_id = current_user.id
    @shop_product.country_code = session['country_code']
    respond_to do |format|
      if @shop_product.save
        ShopMailer.with(shop_product: @shop_product).new_product_email.deliver_later
        format.html { redirect_to shop_path, notice: t('flash.shop_product_created') }
        format.json { render :show, status: :created, location: @shop_product }
      else
        format.html { render :new, status: :unprocessable_content, alert: t('flash.shop_product_not_created') }
        format.json { render json: @shop_product.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /shop/products/1 or /shop/products/1.json
  def update
    respond_to do |format|
      if @shop_product.update(shop_product_params)
        format.html { redirect_to shop_path, notice: t('flash.shop_product_updated') }
        format.json { render :show, status: :ok, location: @shop_product }
      else
        format.html { render :edit, status: :unprocessable_content, alert: t('flash.shop_product_not_updated') }
        format.json { render json: @shop_product.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /shop/products/1 or /shop/products/1.json
  def destroy
    @shop_product.destroy
    respond_to do |format|
      format.html { redirect_to shop_path, notice: t('flash.shop_product_deleted') }
      format.json { head :no_content }
    end
  end

  # PATCH/PUT /shop/products/1/move_down
  def move_down
    respond_to do |format|
      if @shop_product.move_position_down(Shop::Product.where(user_id: current_user.id))
        format.html { redirect_to shop_path }#, notice: t('flash.shop_product_updated') }
        format.json { render :show, status: :ok, location: @shop_product }
      else
        format.html { redirect_to shop_path, alert: t('flash.shop_product_not_updated') }
        format.json { render json: @shop_product.errors, status: :unprocessable_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop_product
      @shop_product = Shop::Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shop_product_params
      params.require(:shop_product).permit(
        :name, :description, :currency, :price, :shipping_national, :stock,
        :is_hidden, :image_link, :image_height, :image_width, :subtype,
        :shipping_international, :max_quantity_per_package, :variants,
        :shipping_international_eu
      )
    end

    def authenticate_seller!
      unless current_user.present? && (current_user.admin? || current_user.has_role?("seller"))
        respond_to do |format|
          format.html { redirect_to shop_path, alert: t('flash.alert.unauthorized') }
          format.json { render json: {}, status: :unauthorized }
        end
      end
    end

    def authenticate_product_creator!
      unless current_user.present? && (@shop_product.user_id == current_user.id || current_user.super_admin?)
        respond_to do |format|
          format.html { redirect_to shop_path, alert: t('flash.alert.unauthorized') }
          format.json { render json: @shop_product.errors, status: :unauthorized }
        end
      end
    end
end
