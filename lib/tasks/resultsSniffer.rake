require 'nokogiri'
require 'open-uri'

namespace :resultsSniffer do
  foundTournaments = []
  root = 'https://braacket.com'

  desc "braacket.com -> Find and create all tournaments, players, matches and results"
  task all: :environment do
    Rake::Task["resultsSniffer:createTournaments"].invoke
    # Rake::Task["resultsSniffer:findPlayers"].invoke
    Rake::Task["resultsSniffer:createMatches"].invoke
    # Rake::Task["resultsSniffer:createResults"].invoke
    puts "\n"
    puts "done"
  end

  desc "Find and create past external tournaments from braacket.com"
  task createTournaments: :environment do
    link = 'https://braacket.com/league/ALLOFTHEM/tournament?rows=200'
    puts "\nSniffing #{link}..."
    doc = Nokogiri::HTML(open(link))
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
      # externalTournament.setup = true
      externalTournament.started = true
      externalTournament.finished = true
      externalTournament.active = true
      foundTournaments << externalTournament
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
    foundTournaments.each_with_index do |t, i|
      # find all players per tournament
      players = []
      link = t.external_registration_link + '/player?rows=200'
      puts "\nSniffing #{link}..."
      doc = Nokogiri::HTML(open(link))
      doc.css('table tbody tr').each do |tr|
        player = ''
        if tr.css('td a')[1].nil?
          player = tr.css('td a')[0].text.strip.split('[').first
        else
          player = tr.css('td a')[1]['aria-label'].strip
        end
        player = player.gsub(' (invitation pending)', '')
        player = player.split('|')[1].strip if player.split('|').length > 1
        if !players.include?(player)
          players << player
        end
      end
      # get tournament from the DB and add the found players
      externalTournament = Tournament.find_by(name: t.name)
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
        puts 'Tournament: ' + t.name + ' not found!'
      end
    end
  end

  desc "Find and create matches from braacket.com and add them to it's external tournament"
  task createMatches: :environment do
    foundTournaments.each_with_index do |t, i|
      tournament = Tournament.find_by(name: t.name)
      puts "\nSearching for all matches from #{t.name}..."
      if !tournament.challonge_tournament_id.nil?
        puts 'this tournament has a challonge id -> continue with the next tournament'
        next  # continue
      end
      doc = Nokogiri::HTML(open(t.external_registration_link + '/match'))
      matchURLs = []
      doc.css('div.my-panel-collapsed')[0].css('a').each do |a|
        matchURLs << root + a['href']
      end
      matchURLs.each do |mURL|
        link = mURL + 'mode=table&display=1&status=2'
        puts "  Sniffing #{link}..."
        doc = Nokogiri::HTML(open(link))
        doc.css('table.tournament_encounter-row').each_with_index do |ter, i|
          p1 = ter.css('a')[0].text.split('[').first.gsub(' (invitation pending)', '')
          p1 = p1.split('|')[1].strip if p1.split('|').length > 1
          p2 = ter.css('a')[1].text.split('[').first.gsub(' (invitation pending)', '')
          p2 = p2.split('|')[1].strip if p2.split('|').length > 1
          rp1 = ter.css('td.tournament_encounter-score')[0].text.strip.to_i
          rp2 = ter.css('td.tournament_encounter-score')[1].text.strip.to_i
          puts '    ' + rp1.to_s + ' -> ' + p1
          puts '    ' + rp2.to_s + ' -> ' + p2
          player1 = Player.find_by(gamer_tag: p1)
          player2 = Player.find_by(gamer_tag: p2)
          if player1.nil? then puts "    couldn't find player1" end
          if player2.nil? then puts "    couldn't find player2" end
          if !player1.nil? && !player2.nil?
            # found both players -> create a match if braacketMatchId is not taken yet
            braacketMatchId = mURL[-13..-2] + '_' + i.to_s
            match = Match.find_by(braacket_match_id: braacketMatchId)
            if match.nil?
              match = Match.new
              match.braacket_match_id = braacketMatchId
              match.tournament = tournament
              match.player1_id = player1.id
              match.player2_id = player2.id
              match.player1_score = rp1
              match.player2_score = rp2
              if match.save
                puts "    -> Created match: #{braacketMatchId}"
              else
                puts "    -> The match: #{braacketMatchId} couldn't be saved!"
                if match.errors.any?
                  match.errors.full_messages.each do |message|
                    puts "    ==> " + message
                  end
                  puts "\n"
                end
              end
            else
              puts "    -> The match: #{braacketMatchId} already exists"
            end
          end
          puts '    -------------'
        end
      end
    end
  end

end
