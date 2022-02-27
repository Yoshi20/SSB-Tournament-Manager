class CommunitiesController < ApplicationController
  before_action { @section = 'communities' }

  # GET /communities
  def index
  end

  # GET /communities/
  def nrw
    community_federal_states = ['NW']
    discord_keys = ['Aba35kP', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/hessen
  def hessen
    community_federal_states = ['HE', 'RP', 'SL']
    discord_keys = ['gdhCQpzKb2', 'Q49Dbky', 'phzRTMw', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/nds
  def nds
    community_federal_states = ['NI', 'HB']
    discord_keys = ['0X3myOFZHGCpW1G0', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/bayern
  def bayern
    community_federal_states = ['BY']
    discord_keys = ['tm2azmK', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/berlin
  def berlin
    community_federal_states = ['BE', 'BB']
    discord_keys = ['6r76SkA', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/norden
  def norden
    community_federal_states = ['SH', 'HH', 'MV']
    discord_keys = ['GHS8Q5Y', 'udNKmTK', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/osten
  def osten
    community_federal_states = ['SN', 'ST', 'TH']
    discord_keys = ['rBzNfVD', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  # GET /communities/bawu
  def bawu
    community_federal_states = ['BW']
    discord_keys = ['ur4JzUT', 'XpjNsRp']
    @next_region_tournaments = Tournament.all_de.active.upcoming.where(federal_state: community_federal_states).order(date: :asc).limit(10)
    @region_administartors = User.all_de.where(is_admin: true).joins(:player).where("players.federal_state IN (?)", community_federal_states)
    @discord_invites_json = []
    discord_keys.each do |key|
      @discord_invites_json << request_discord_invite(key)
    end
    @discord_invites_json.compact
  end

  private

  require 'open-uri'
  require 'json'
  def request_discord_invite(key)
    Rails.cache.fetch("discord_invite_#{key}", expires_in: 1.day) do
      url = "https://discord.com/api/v9/invites/#{key}?with_counts=true"
      puts "Requesting: GET #{url}"
      begin
        json_data = JSON.parse(URI.open(url).read)
      rescue OpenURI::HTTPError => ex
        puts ex
      end
      if json_data.present? && !json_data["guild"].nil?
        json_data
      else
        puts "=> No guild parameter found! json_data = #{json_data.to_s}"
        break # do not cache if theres no valid data
      end
    end
  end

end
