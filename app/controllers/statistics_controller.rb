class StatisticsController < ApplicationController
  before_action { @section = 'statistics' }

  # GET /statistics
  # GET /statistics.json
  def index
    @players = Player.all_ch
    @player_count_total = @players.count - 4 # do not count bye0, bye1 bye2 & bye3
    @player_count_2019 = @players.from_2019.count
    @player_count_2020 = @players.from_2020.count
    @player_count_2021 = @players.from_2021.count
    @player_count_2022 = @players.from_2022.count
  end

end
