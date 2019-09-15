class PlayersController < ApplicationController
  require 'will_paginate/array'

  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action { @section = 'players' }

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
    # handle search parameter
    if params[:search].present?
      @players = @players.search(params[:search])
      if @players.empty?
        flash.now[:alert] = t('flash.alert.search_players')
      end
    end
    # handle sort parameter
    sort = params[:sort]
    if sort.present?
      case sort
      when 'win_loss_ratio'
        if params[:order] == "desc"
          @players = @players.sort_by do |p|
            [p.win_loss_ratio, -p.created_at.to_i]
          end.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
        else
          @players = @players.sort_by do |p|
            [p.win_loss_ratio, -p.created_at.to_i]
          end.reverse.paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
        end
      else
        @players = @players.order("players.?".gsub('?', params[:sort])).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
      end
    else
      @players = @players.order(created_at: :desc).paginate(page: params[:page], per_page: Player::MAX_PLAYERS_PER_PAGE)
    end
    # handle the order parameter
    if params[:order] == "desc" and !@players.is_a?(Array)
      @players = @players.reverse_order
    end
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # # GET /players/new
  # def new
  #   @player = Player.new
  # end

  # GET /players/1/edit
  def edit
  end

  # # POST /players
  # # POST /players.json
  # def create
  #   @player = Player.new(player_params)
  #
  #   respond_to do |format|
  #     if @player.save
  #       format.html { redirect_to @player, notice: 'Player was successfully created.' }
  #       format.json { render :show, status: :created, location: @player }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @player.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      old_gamer_tag = @player.gamer_tag
      if @player.update(player_params)
        # update main_characters
        @player.main_characters.clear
        player_params[:main_characters].split(',').each do |char|
          @player.main_characters << char.strip.downcase.gsub('.', '').gsub(' ', '_')
        end
        @player.save
        # update all tournament ranking_strings if the gamer_tag was changed and create an AlternativeGamerTag
        if @player.gamer_tag != old_gamer_tag
          Tournament.all.each do |t|
            if t.ranking_string.to_s.include?(old_gamer_tag)
              t.update(ranking_string: t.ranking_string.gsub(old_gamer_tag, @player.gamer_tag))
            end
          end
          AlternativeGamerTag.create(player_id: @player.id, gamer_tag: old_gamer_tag)
        end
        # update alternative_gamer_tags if it was changed
        alts = ""
        @player.alternative_gamer_tags.each { |alt| alts += "#{alt.gamer_tag}, " }
        if params[:alternative_gamer_tags].present? and params[:alternative_gamer_tags] != alts
          params[:alternative_gamer_tags].split(',').each do |alt|
            AlternativeGamerTag.create(player_id: @player.id, gamer_tag: alt.strip)
          end
        end
        # render
        format.html { redirect_to @player, notice: t('flash.notice.player_updated') }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /players/unregistered
  def unregistered
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:gamer_tag, :points, :participations,
        :self_assessment, :tournament_experience, :comment, :best_rank, :wins,
        :losses, :main_characters, :created_at, :updated_at, :canton, :gender,
        :birth_year, :prefix, :discord_username)
    end

end
