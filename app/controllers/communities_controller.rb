class CommunitiesController < ApplicationController
  before_action :set_community, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, only: [:new, :edit, :create, :update, :destroy]
  before_action :authenticate_community_creator!, only: [:edit, :update, :destroy]
  before_action { @section = 'communities' }

  # GET /communities
  def index
    if ['fr', 'it', 'uk', 'pt'].include?(session['country_code'])
      @communities = Community.all_from(session['country_code']).order(region: :desc)
      i = -1
      prevRegion = ''
      @communities_regions_array = []
      @communities.each do |c|
        if c.region != prevRegion
          i = i + 1
          @communities_regions_array[i] = []
        end
        @communities_regions_array[i] << c
        prevRegion = c.region
      end
    end
    render "index_#{session['country_code']}"
  end

  # GET /communities/1
  # GET /communities/1.json
  def show
    discord_keys = @community.discord.split(',').map(&:strip)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/new
  def new
    @community = Community.new
    @community.country_code = session['country_code']
  end

  # GET /communities/1/edit
  def edit
  end

  # POST /communities
  # POST /communities.json
  def create
    @community = Community.new(community_params)
    @community.country_code = session['country_code']
    @community.user_id = current_user.id
    respond_to do |format|
      if @community.save
        format.html { redirect_to @community, notice: t('flash.notice.community_created') }
        format.json { render :show, status: :created, location: @community }
      else
        format.html { render :new }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /communities/1
  # PATCH/PUT /communities/1.json
  def update
    respond_to do |format|
      if @community.update(community_params)
        format.html { redirect_to @community, notice: t('flash.notice.community_updated') }
        format.json { render :show, status: :ok, location: @community }
      else
        format.html { render :edit }
        format.json { render json: @community.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communities/1
  # DELETE /communities/1.json
  def destroy
    @community.destroy
    respond_to do |format|
      format.html { redirect_to communities_path, notice: t('flash.notice.community_deleted') }
      format.json { head :no_content }
    end
  end

  # GET /communities/
  def nrw
    community_regions = ['NW']
    discord_keys = ['Aba35kP', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/hessen
  def hessen
    community_regions = ['HE', 'RP', 'SL']
    discord_keys = ['gdhCQpzKb2', 'Q49Dbky', 'phzRTMw', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/nds
  def nds
    community_regions = ['NI', 'HB']
    discord_keys = ['0X3myOFZHGCpW1G0', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/bayern
  def bayern
    community_regions = ['BY']
    discord_keys = ['tm2azmK', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/berlin
  def berlin
    community_regions = ['BE', 'BB']
    discord_keys = ['6r76SkA', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/norden
  def norden
    community_regions = ['SH', 'HH', 'MV']
    discord_keys = ['GHS8Q5Y', 'udNKmTK', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/osten
  def osten
    community_regions = ['SN', 'ST', 'TH']
    discord_keys = ['rBzNfVD', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/bawu
  def bawu
    community_regions = ['BW']
    discord_keys = ['ur4JzUT', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_from(session['country_code']).active.upcoming.where(region: community_regions).order(date: :asc).limit(10)
    # @region_administartors = User.all_from(session['country_code']).where(is_admin: true).joins(:player).where("players.region IN (?)", community_regions)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << Request.discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/regions/:name
  def regions
    @region = params['name']
    @communities = Community.all_from(session['country_code']).where(region: @region).order(name: :desc)
    respond_to do |format|
      format.html { render "region" }
    end
  end

  def character_discords
    @discords = [
      ["banjo_and_kazooie", "fEyhZrn"], ["bayonetta", "DC36FXc"], ["bowser", "nF9kx7W"],
      ["bowser_jr", "eFDYEfG"], ["byleth", "KDTPNfs"], ["captain_falcon", "zxxdHxU"],
      ["chrom", "wwnhVjS"], ["cloud", "acHKeyQ"], ["corrin", "F98MKp8"], ["daisy", "5EDcCC9"],
      ["dark_pit", "tRzaFXP"],  ["dark_samus", "e9vyVF2"], ["diddy_kong", "aNm6hmkwjV"],
      ["donkey_kong", "bt72UvP"], ["dr_mario", "3b2v576"], ["duck_hunt", "MEmd3C3"],
      ["falco", "EdBwraB"], ["fox", "4JfXSG9"], ["ganondorf", "3G7akxP"], ["greninja", "ERX3BSr"],
      ["hero", "sevQSfS"], ["ice_climbers", "eDqA2Xp"], ["ike", "hT6zdue"], ["incineroar", "QhyTjn7"],
      ["inkling", "TjRTWhz"], ["isabelle", "YNdU5B8"], ["jigglypuff", "dFySWuP"],
      ["joker", "x6cHgmM"], ["kazuya", "Njtpw4W656"], ["ken", "CPptRsR"], ["king_dedede", "rcseuAP"],
      ["king_k_rool", "sQCDnKx"], ["kirby", "AjFA47Q"], ["link", "8pm4FBB"], ["little_mac", "fUmq4cJ"],
      ["lucario", "ptKYD7v"], ["lucas", "yWV5NN8"], ["lucina", "XRA9RkM"], ["luigi", "DzKnQeX"],
      ["mario", "3b2v576"], ["marth", "XRA9RkM"], ["mega_man", "sKp954t"], ["meta_knight", "THs9u5f"],
      ["mewtwo", "JFtDMph"], ["mii_brawler", "2TRzK6U"], ["mii_gunner", "2TRzK6U"],
      ["mii_swordfighter", "2TRzK6U"], ["min_min", "phqePSW"], ["mr_game_and_watch", "MUMcDJF"],
      ["ness", "3c5JPBh"], ["olimar", "6yWuNQa"], ["pac_man", "CmDjRXz"], ["palutena", "2hSRYg2"],
      ["peach", "5EDcCC9"], ["pichu", "5NBk3MT"], ["pikachu", "4Zu58Q5"], ["piranha_plant", "xrHCvpX"],
      ["pit", "tRzaFXP"], ["pokemon_trainer", "Y6dhCsM"], ["pyra_and_mythra", "7g8gY7wQJH"],
      ["richter", "ZDvJWdz"], ["ridley", "yenwRqm"], ["rob", "rSx8MSf"], ["robin", "Gpc7Dbu"],
      ["rosalina_and_luma", "zfvA8xV"], ["roy", "wwnhVjS"], ["ryu", "CPptRsR"],
      ["samus", "e9vyVF2"], ["sephiroth", "APW2QScwW7"], ["sheik", "edvYN57"], ["shulk", "GneEZAC"],
      ["simon", "ZDvJWdz"], ["snake", "WgWhze4"], ["sonic", "NVWzs5M"], ["sora", "AaZjVBnANh"],
      ["steve", "7nK7ADz"], ["terry", "WXW26zN"], ["toon_link", "mSU95AB"], ["villager", "9N6Rr3B"],
      ["wario", "jTDGUC2"], ["wii_fit_trainer", "NcGbfek"], ["wolf", "RYC3cVDuuq"],
      ["yoshi", "A88DP87"], ["young_link", "zcZFt7x"], ["zelda", "ke3SBMC"], ["zero_suit_samus", "vHTu5sQ"],
    ]
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_community
    @community = Community.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def community_params
    params.require(:community).permit(
      :name, :city, :department, :region, :country_code, :discord, :twitter,
      :instagram, :facebook, :youtube, :twitch
    )
  end

  def authenticate_admin!
    unless current_user.present? && (current_user.admin? || current_user.has_role?("community_editor"))
      respond_to do |format|
        format.html { redirect_to communities_path, alert: t('flash.alert.unauthorized') }
        format.json { render json: {}, status: :unauthorized }
      end
    end
  end

  def authenticate_community_creator!
    unless current_user.present? && (@community.user_id == current_user.id || current_user.admin?)
      respond_to do |format|
        format.html { redirect_to @community, alert: t('flash.alert.unauthorized') }
        format.json { render json: @community.errors, status: :unauthorized }
      end
    end
  end

end
