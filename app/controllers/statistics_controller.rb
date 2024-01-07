class StatisticsController < ApplicationController
  before_action { @section = 'statistics' }

  # GET /statistics
  # GET /statistics.json
  def index
    @players = Player.all_from(session['country_code'])
    @player_count_total = @players.count - (session['country_code'] == 'ch' ? 4 : 0) # do not count bye0, bye1 bye2 & bye3
    if session['country_code'] == 'ch'
      @player_count_2019 = @players.from_2019.count
      @player_count_2020 = @players.from_2020.count
      @player_count_2021 = @players.from_2021.count
      @player_count_2022 = @players.from_2022.count
      @player_count_2023 = @players.from_2023.count
      @player_count_2024 = @players.from_2024.count
      @player_count_active_365 = @players.includes(:tournaments).where(tournaments: {date: 365.days.ago.. Date.today}).count
      @player_count_active_90 = @players.includes(:tournaments).where(tournaments: {date: 90.days.ago.. Date.today}).count
      @player_count_active_30 = @players.includes(:tournaments).where(tournaments: {date: 30.days.ago.. Date.today}).count
      @player_count_active_7 = @players.includes(:tournaments).where(tournaments: {date: 7.days.ago.. Date.today}).count
    end
  end

end
