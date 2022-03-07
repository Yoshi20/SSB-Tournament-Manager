class VideosController < ApplicationController
  before_action { @section = 'videos' }

  # GET /videos
  # GET /videos.json
  def index
    @players = Player.all_from(session['country_code']).where("youtube_video_ids <> '' is true").order(updated_at: :desc).paginate(page: params[:page], per_page: Player::MAX_PLAYER_VIDEOS_PER_PAGE)
  end

end
