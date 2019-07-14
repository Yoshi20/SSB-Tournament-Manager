class RankingsController < ApplicationController
  before_action { @section = 'rankings' }

  # GET /rankings
  # GET /rankings.json
  def index
    if params[:filter].nil? or params[:filter] == 'all'
      # @players = Player.all.includes(:user).order(points: :desc, participations: :asc, created_at: :asc)
      @players = []  # blup: no results for now
    elsif params[:filter] == 'major'
      @players = Player.includes(:user).includes(:results).where("results.major_name LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:major])}%").references(:results).sort_by do |p|
        p.results_sum(params[:major]) << -p.created_at.to_i
      end.reverse
    elsif params[:filter] == 'seed_points'
      @players = Player.all.includes(:user).order(points: :desc, participations: :asc, created_at: :asc).sort_by do |p|
        [p.seed_points, -p.created_at.to_i]
      end.reverse
    elsif helpers.tournament_cities.include?(params[:filter].capitalize)
      city = params[:filter].capitalize
      @players = Player.includes(:user).includes(:results).where(results: {city: city}).sort_by do |p|
        p.results_sum(city) << -p.created_at.to_i
      end.reverse
    end
  end

end
