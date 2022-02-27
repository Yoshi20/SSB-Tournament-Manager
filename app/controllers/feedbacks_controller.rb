class FeedbacksController < ApplicationController
  before_action :set_feedback, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_feedback_creator!, only: [:edit, :update, :destroy]
  before_action { @section = 'feedbacks' }

  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @feedbacks = Feedback.all.order(created_at: :desc).paginate(page: params[:page], per_page: Feedback::MAX_FEEDBACKS_PER_PAGE)
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
  end

  # GET /feedbacks/new
  def new
    @feedback = Feedback.new
  end

  # GET /feedbacks/1/edit
  def edit
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(feedback_params)
    respond_to do |format|
      if @feedback.save
        User.all_from(session['country_code']).where(is_super_admin: true).each do |admin|
          FeedbackMailer.with(feedback: @feedback, admin: admin).new_feedback_email.deliver_later
        end
        format.html { redirect_to feedbacks_path, notice: t('flash.notice.feedback_created') }
        format.json { render :show, status: :created, location: @feedback }
      else
        format.html { render :new }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feedbacks/1
  # PATCH/PUT /feedbacks/1.json
  def update
    respond_to do |format|
      p = feedback_params
      p.delete('user_id') unless @feedback.new_record?
      if current_user.super_admin?
        if feedback_params[:response] != @feedback.response and feedback_params[:response] != ""
          FeedbackMailer.with(feedback: @feedback, admin: current_user).feedback_response_email.deliver_later
        else
          p.delete('response_username')  # do not update response_username when an admin didn't write/change the response
        end
      end
      if @feedback.update(p)
        format.html { redirect_to @feedback, notice: t('flash.notice.feedback_updated') }
        format.json { render :show, status: :ok, location: @feedback }
      else
        format.html { render :edit }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to feedbacks_url, notice: t('flash.notice.feedback_deleted') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:user_id, :text, :response, :response_username, :created_at, :updated_at)
    end

    def authenticate_feedback_creator!
      unless current_user.present? && (@feedback.user_id == current_user.id || current_user.super_admin?)
        respond_to do |format|
          format.html { redirect_to @feedback, alert: t('flash.alert.unauthorized') }
          format.json { render json: @feedback.errors, status: :unauthorized }
        end
      end
    end

end
