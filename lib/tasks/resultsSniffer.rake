require 'nokogiri'
require 'open-uri'

namespace :resultsSniffer do
  desc "braacket.com -> Find and create all tournaments, players, matches and results"
  task all: :environment do
    Rake::Task["resultsSniffer:findTournaments"].invoke
    Rake::Task["resultsSniffer:findPlayers"].invoke
    # Rake::Task["resultsSniffer:createMatches"].invoke
    # Rake::Task["resultsSniffer:createResults"].invoke
    puts "\n"
    puts "done"
  end

  desc "Find and create past external tournaments from braacket.com"
  task findTournaments: :environment do
    puts 'Sniffing https://braacket.com/league/ALLOFTHEM/tournament...'
    root = 'https://braacket.com'
    doc = Nokogiri::HTML(open('https://braacket.com/league/ALLOFTHEM/tournament?rows=200'))
    doc.css('div.my-panel-mosaic').each_with_index do |p, i|
      # each tournament panel (p)
      externalTournament = Tournament.new
      externalTournament.subtype = 'external'
      p.css('div.panel-heading a').each do |a|
        externalTournament.name = a.text.strip unless a.text.strip.empty?
      end
      externalTournament.city = ''
      p.css('div.panel-heading td.ellipsis').each do |td|
        td.css('a').each do |a|
          externalTournament.external_registration_link = root + a['href']
        end
      end
      seatsString = ''
      if p.css("div.my-dashboard-values-sub").count < 6
        externalTournament.date = Date.parse(p.css("div.my-dashboard-values-sub")[1].css('div')[1].text)
        seatsString = p.css("div.my-dashboard-values-sub")[3].css('div')[1].text.strip
      else
        externalTournament.date = Date.parse(p.css("div.my-dashboard-values-sub")[2].css('div')[1].text)
        seatsString = p.css("div.my-dashboard-values-sub")[4].css('div')[1].text.strip
      end
      externalTournament.total_seats = seatsString[seatsString.index('/')+1..-1].to_i
      externalTournament.is_registration_allowed = false
      externalTournament.active = true
      if externalTournament.save
        puts "-> Created: \"" + externalTournament.name + "\"\n\n"
      else
        puts "-> \"" + externalTournament.name + "\" couldn't be saved!"
        if externalTournament.errors.any?
          externalTournament.errors.full_messages.each do |message|
            puts "==> " + message
          end
          puts "\n"
        end
      end
    end
  end

  desc "Find players from braacket.com and add them to it's external tournament"
  task findPlayers: :environment do
    puts 'Sniffing https://braacket.com/league/ALLOFTHEM/tournament...'
    root = 'https://braacket.com'
    doc = Nokogiri::HTML(open('https://braacket.com/league/ALLOFTHEM/tournament?rows=200'))
    doc.css('div.my-panel-mosaic').each_with_index do |p, i|
      # each tournament panel (p)
      et = Tournament.new
      et.subtype = 'external'
      p.css('div.panel-heading a').each do |a|
        et.name = a.text.strip unless a.text.strip.empty?
      end
      et.city = ''
      p.css('div.panel-heading td.ellipsis').each do |td|
        td.css('a').each do |a|
          et.external_registration_link = root + a['href']
        end
      end
      seatsString = ''
      if p.css("div.my-dashboard-values-sub").count < 6
        et.date = Date.parse(p.css("div.my-dashboard-values-sub")[1].css('div')[1].text)
        seatsString = p.css("div.my-dashboard-values-sub")[3].css('div')[1].text.strip
      else
        et.date = Date.parse(p.css("div.my-dashboard-values-sub")[2].css('div')[1].text)
        seatsString = p.css("div.my-dashboard-values-sub")[4].css('div')[1].text.strip
      end
      et.total_seats = seatsString[seatsString.index('/')+1..-1].to_i
      et.is_registration_allowed = false
      et.active = true

      # find all players per tournament
      players = []
      doc = Nokogiri::HTML(open(et.external_registration_link + '/player?rows=200'))
      doc.css('table tbody tr').each do |tr|
        player = ''
        if tr.css('td a')[1].nil?
          player = tr.css('td a')[0].text.strip.split('[').first
        else
          player = tr.css('td a')[1]['aria-label'].strip
        end
        player = player.gsub(' (invitation pending)', '')
        if !players.include?(player)
          players << player
        end
      end

      # get tournament from the DB
      externalTournament = Tournament.find_by(name: et.name, subtype: et.subtype, total_seats: et.total_seats, date: et.date)
      if externalTournament.present?
        puts 'Searching for players to add to ' + externalTournament.name + '...'
        allGamerTags = Player.all.map {|p| p.gamer_tag}
        etGamerTags = externalTournament.players.map {|p| p.gamer_tag}
        players.each do |p|
          # check if player exists in the DB but was not added to the tournament yet
          if allGamerTags.include?(p) and !etGamerTags.include?(p)
            externalTournament.players << Player.find_by(gamer_tag: p)
            puts '-> Added ' + p
          end
        end
      else
        puts 'Tournament: ' + et.name + 'not found!'
      end

    end

  end

end

# externalTournaments.each do |et|
#   puts et.name
#
#   matchURLs = []
#   doc = Nokogiri::HTML(open(et.url + '/match'))
#   doc.css('div.my-panel-collapsed')[0].css('a').each do |a|
#     matchURLs << root + a['href']
#   end
# end
# matchURLs.each do |mURL|
#   puts mURL
#   doc = Nokogiri::HTML(open(mURL + 'mode=table&display=1&status=2'))
#   doc.css('table.tournament_encounter-row').each do |ter|
#     p1 = ter.css('a')[0].text.split('[').first
#     p2 = ter.css('a')[1].text.split('[').first
#     rp1 = ter.css('td.tournament_encounter-score')[0].text.strip.to_i
#     rp2 = ter.css('td.tournament_encounter-score')[1].text.strip.to_i
#     puts rp1.to_s + ' -> ' + p1
#     puts rp2.to_s + ' -> ' + p2
#     puts '-------------'
#   end
# end
# puts ''
