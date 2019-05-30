class RankingsController < ApplicationController
  before_action { @section = 'rankings' }

  # GET /rankings
  # GET /rankings.json
  def index
    if params[:filter].nil? or params[:filter] == 'all'
      @players = Player.all.includes(:user).order(points: :desc, participations: :asc, created_at: :asc)
    elsif params[:filter] == 'major'
      # @players = Player.includes(:user).includes(:results).where.not(results: {major_name: nil}).order(points: :desc, participations: :asc, created_at: :asc)
      @players = Player.includes(:user).includes(:results).where("results.major_name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:major])}%").references(:results).sort_by do |p|
        p.results_sum(params[:major]) << p.created_at
      end.reverse
    elsif helpers.tournament_cities.include?(params[:filter].capitalize)
      city = params[:filter].capitalize
      @players = Player.includes(:user).includes(:results).where(results: {city: city}).sort_by do |p|
        p.results_sum(city) << p.created_at
      end.reverse
    end
    @started_and_finished_tournaments_count_2019 = Tournament.active_2019.where(started: true, finished: true).count
  end

end
