class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_news_editor!, only: [:new, :create]
  before_action :authenticate_news_creator!, only: [:edit, :update, :destroy]
  before_action { @section = 'news' }

  # GET /news
  # GET /news.json
  def index
    @news = News.all_from(session['country_code']).order(created_at: :desc).paginate(page: params[:page], per_page: News::MAX_NEWS_PER_PAGE)
  end

  # GET /news/1
  # GET /news/1.json
  def show
    if @latest_news.present? && @news.id == @latest_news.first.id
      cookies.permanent[:latest_news_id] = @latest_news.first.id.to_s
    end
  end

  # GET /news/new
  def new
    @news = News.new
    @news.country_code = session['country_code']
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news
  # POST /news.json
  def create
    @news = News.new(news_params)
    @news.country_code = session['country_code']
    respond_to do |format|
      if @news.save
        format.html { redirect_to news_index_path, notice: t('flash.notice.news_created') }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new }
        format.json { render json: @news.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params)
        format.html { redirect_to @news, notice: t('flash.notice.news_updated') }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit }
        format.json { render json: @news.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    second_latest_news_id = @latest_news.second.id if cookies['latest_news_id'].present? && @latest_news.present? && @latest_news.second.present?
    @news.destroy
    if second_latest_news_id
      cookies.permanent[:latest_news_id] = second_latest_news_id
    end
    respond_to do |format|
      format.html { redirect_to news_index_path, notice: t('flash.notice.news_deleted') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_params
      params.require(:news).permit(:user_id, :title, :teaser, :text, :created_at, :updated_at)
    end

    def authenticate_news_editor!
      unless current_user.present? && (current_user.admin? || current_user.has_role?("news_editor"))
        respond_to do |format|
          format.html { redirect_to news_index_path, alert: t('flash.alert.unauthorized') }
          format.json { render json: {}, status: :unauthorized }
        end
      end
    end

    def authenticate_news_creator!
      unless current_user.present? && (@news.user_id == current_user.id || current_user.admin?)
        respond_to do |format|
          format.html { redirect_to @news, alert: t('flash.alert.unauthorized') }
          format.json { render json: @news.errors, status: :unauthorized }
        end
      end
    end

end
