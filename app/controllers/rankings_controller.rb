class RankingsController < ApplicationController
  require 'will_paginate/array'

  before_action { @section = 'rankings' }

  # GET /rankings
  # GET /rankings.json
  def index
    @players = Player.all_from(session['country_code'])
    # @players_2020 = Player.all_from(session['country_code']).includes(:user).includes(:results).where("results.created_at >= ?", Time.local(2020,1,1)).references(:results)
    # @players_2019 = Player.all_from(session['country_code']).includes(:user).includes(:results).where("results.created_at >= ?", Time.local(2019,1,1)).references(:results)
    if params[:filter].nil? or params[:filter] == 'all'
      @players = @players.where('participations >= 3').sort_by do |p|
        [p.points.to_f/p.participations, p.participations, -p.created_at.to_i]
      end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
      # @players_2019 = @players_2019.where('participations >= 3').sort_by do |p|
      #   [p.points.to_f/p.participations, p.participations, -p.created_at.to_i]
      # end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    elsif params[:filter] == 'participations'
      @players = @players.where('participations > 0').order(participations: :desc, points: :desc, created_at: :asc).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
      # @players_2019 = @players_2019.where('participations > 0').order(participations: :desc, points: :desc, created_at: :asc).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    elsif params[:filter] == 'seed_points'
      @players = helpers.seed_players(@players).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
      # @players_2019 = helpers.seed_players(@players_2019).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    elsif params[:filter] == 'major' && params[:major].present?
      @players = @players.where('participations > 0').includes(:results).where("results.major_name ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:major])}%").references(:results).sort_by do |p|
        p.results_sum(params[:major]) << -p.created_at.to_i
      end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
      # @players_2019 = @players_2019.where('participations > 0').includes(:results).where("results.major_name ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:major])}%").references(:results).sort_by do |p|
      #   p.results_sum(params[:major]) << -p.created_at.to_i
      # end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    elsif helpers.tournament_cities_with_a_weekly.include?(params[:filter].capitalize)
      city = params[:filter].capitalize
      @players = @players.where('participations > 0').includes(:results).where(results: {city: city}).sort_by do |p|
        p.results_sum(city) << -p.created_at.to_i
      end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
      # @players_2019 = @players_2019.where('participations > 0').includes(:results).where(results: {city: city}).sort_by do |p|
      #   p.results_sum(city) << -p.created_at.to_i
      # end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    end
    render "index_#{session['country_code']}"
  end

end
