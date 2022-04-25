require 'nokogiri'
require 'open-uri'
require "#{Rails.root}/app/helpers/tournaments_helper"
include TournamentsHelper

namespace :results_crawler_uk do
  foundTournaments = []
  notFoundPlayers = []
  root = 'https://braacket.com'

  desc "braacket.com -> Find and create all tournaments, players, matches and results..."
  task all: :environment do
    Rake::Task["results_crawler_uk:createTournaments"].invoke
    Rake::Task["results_crawler_uk:findPlayers"].invoke
    Rake::Task["results_crawler_uk:createMatches"].invoke
    Rake::Task["results_crawler_uk:createResults"].invoke
    puts "\ndone"

    puts "\nCouldn't finde the following #{notFoundPlayers.count} players:"
    nfps = ""
    notFoundPlayers.sort.each_with_index do |p, i|
      nfps += "#{p}, "
      if (i+1)%10 == 0
        puts nfps.strip
        nfps = ""
      end
    end
    puts nfps.strip
    puts "\n"

  end

  desc "Find and create past external tournaments from braacket.com"
  task createTournaments: :environment do
    links = [
      'https://braacket.com/league/SSBUUKPRs/tournament?rows=200',
    ]
    links.each do |link|
      puts "\nCrawling #{link}..."
      doc = Nokogiri::HTML(URI.open(link))
      doc.css('div.my-panel-mosaic').each_with_index do |p, i|
        # each tournament panel (p)
        etName = ""
        p.css('div.panel-heading a').each do |a|
          etName = a.text.strip unless a.text.strip.empty?
        end
        externalTournament = Tournament.find_by(name: etName)
        if !externalTournament.nil?
          if externalTournament.subtype == 'external'
            p.css('div.panel-heading td.ellipsis').each do |td|
              td.css('a').each do |a|
                externalTournament.external_registration_link = root + a['href']
              end
            end
          end
          externalTournament.started = true
          externalTournament.finished = true
          externalTournament.country_code = 'uk'
          if externalTournament.save
            puts "-> Found and updated: \"" + externalTournament.name + "\"\n\n"
            foundTournaments << externalTournament
          else
            puts "-> \"" + externalTournament.name + "\" couldn't be saved!"
            if externalTournament.errors.any?
              externalTournament.errors.full_messages.each do |message|
                puts "==> " + message
              end
              puts "\n"
            end
          end
        else
          externalTournament = Tournament.new
          externalTournament.name = etName
          if externalTournament.name.include?('Weekly')
            # tournament is a weekly -> check if we know it's city
            externalTournament.subtype = 'weekly'
            # externalTournament.city = '?'
            # externalTournament.name.split(' ').each do |word|
            #   if tournament_cities().include?(word)
            #     externalTournament.city = word
            #     break
            #   end
            # end
          else
            externalTournament.subtype = 'external'
            externalTournament.city = ''
          end
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
          externalTournament.country_code = 'uk'
          if externalTournament.save
            puts "-> Created: \"" + externalTournament.name + "\"\n\n"
            foundTournaments << externalTournament
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
    end
  end

  desc "Find players from braacket.com and add them to it's external tournament"
  task findPlayers: :environment do
    allGamerTags = Player.all_from('uk').map {|p| p.gamer_tag}
    allGamerTags += AlternativeGamerTag.all_from('uk').map {|p| p.gamer_tag}
    foundTournaments.each_with_index do |t, i|
      if t.subtype == 'internal'
        puts "\n#{t.name} is an internal tournament -> continue with the next tournament"
        next  # continue
      end
      if t.external_registration_link.nil?
        puts "\n#{t.name}s external registration link is nil! -> continue with the next tournament"
        next  # continue
      end
      # find all players per tournament
      players = []
      link = t.external_registration_link + '/player?rows=200'
      puts "\nCrawling #{link}..."
      doc = Nokogiri::HTML(URI.open(link))
      doc.css('table tbody tr').each do |tr|
        firstGamerTag = tr.css('td a')[0].text.strip.split('[').first
        firstGamerTag = firstGamerTag.gsub(' (invitation pending)', '').strip
        firstGamerTag = firstGamerTag.split('|')[1].strip if firstGamerTag.split('|').length > 1
        gamerTag = ''
        if tr.css('td a')[1].nil?
          gamerTag = firstGamerTag
        else
          gamerTag = tr.css('td a')[1]['aria-label'].strip
          gamerTag = gamerTag.gsub(' (invitation pending)', '').strip
          gamerTag = gamerTag.split('|')[1].strip if gamerTag.split('|').length > 1
          if firstGamerTag != gamerTag
            # try to create an AlternativeGamerTag if the firstGamerTag doesn't match the second
            player = Player.find_by(gamer_tag: gamerTag)
            AlternativeGamerTag.create(player_id: player.id, gamer_tag: firstGamerTag, country_code: 'uk') unless player.nil?
          end
        end
        if !players.include?(gamerTag)
          players << gamerTag
        end
      end
      # get tournament from the DB and add the found players
      externalTournament = Tournament.find_by(name: t.name)
      if externalTournament.present?
        puts 'Searching for players to add to ' + externalTournament.name + '...'
        etGamerTags = externalTournament.players.map {|p| p.gamer_tag}
        players.each do |p|
          # check if player exists in the DB but was not added to the tournament yet
          if allGamerTags.include?(p) && !etGamerTags.include?(p)
            player = Player.find_by(gamer_tag: p)
            if player.nil?
              alt = AlternativeGamerTag.find_by(gamer_tag: p)
              player = alt.player unless alt.nil?
            end
            if !externalTournament.players.include?(player)
              externalTournament.players << player
              puts '-> Added ' + p
            end
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
      if tournament.subtype == 'internal'
        puts 'this tournament is an internal tournament -> continue with the next tournament'
        next  # continue
      end
      if t.external_registration_link.nil?
        puts "this tournaments external registration link is nil! -> continue with the next tournament"
        next  # continue
      end
      doc = Nokogiri::HTML(URI.open(t.external_registration_link + '/match'))
      matchURLs = []
      doc.css('div.my-panel-collapsed')[0].css('a').each do |a|
        matchURLs << root + a['href']
      end
      matchURLs.each do |mURL|
        link = mURL + 'mode=table&display=1&status=2'
        puts "  Crawling #{link}..."
        doc = Nokogiri::HTML(URI.open(link))
        doc.css('table.tournament_encounter-row').each_with_index do |ter, i|
          p1 = ter.css('a')[0].text.split('[').first.gsub(' (invitation pending)', '').strip
          p1 = p1.split('|')[1].strip if p1.split('|').length > 1
          p2 = ter.css('a')[1].text.split('[').first.gsub(' (invitation pending)', '').strip
          p2 = p2.split('|')[1].strip if p2.split('|').length > 1
          rp1 = ter.css('td.tournament_encounter-score')[0].text.strip.to_i
          rp2 = ter.css('td.tournament_encounter-score')[1].text.strip.to_i
          puts '    ' + rp1.to_s + ' -> ' + p1
          puts '    ' + rp2.to_s + ' -> ' + p2
          player1 = Player.find_by(gamer_tag: p1)
          if player1.nil?
            alt1 = AlternativeGamerTag.find_by(gamer_tag: p1)
            player1 = alt1.player unless alt1.nil?
          end
          player2 = Player.find_by(gamer_tag: p2)
          if player2.nil?
            alt2 = AlternativeGamerTag.find_by(gamer_tag: p2)
            player2 = alt2.player unless alt2.nil?
          end
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

  desc "Find and create results from braacket.com and add them to it's external tournament and player"
  task createResults: :environment do
    allGamerTags = Player.all_from('uk').map {|p| p.gamer_tag}
    allGamerTags += AlternativeGamerTag.all_from('uk').map {|p| p.gamer_tag}
    foundTournaments.each_with_index do |t, i|
      tournament = Tournament.find_by(name: t.name)
      puts "\nSearching for all results from #{t.name}..."
      if tournament.results.count == tournament.players.count
        puts 'this tournament has already all results for the moment -> continue with the next tournament'
        next  # continue
      end
      if tournament.subtype == 'internal'
        puts 'this tournament is an internal tournament -> continue with the next tournament'
        next  # continue
      end
      if t.external_registration_link.nil?
        puts "this tournaments external registration link is nil! -> continue with the next tournament"
        next  # continue
      end
      doc = Nokogiri::HTML(URI.open(t.external_registration_link + '/ranking?rows=200'))
      doc.css('div.my-panel-collapsed').css('tbody').css('tr').each do |tr|
        firstGamerTag = tr.css('td a')[0].text.strip.split('[').first
        firstGamerTag = firstGamerTag.gsub(' (invitation pending)', '').strip
        firstGamerTag = firstGamerTag.split('|')[1].strip if firstGamerTag.split('|').length > 1
        gamerTag = ''
        if tr.css('td a')[1].nil?
          gamerTag = firstGamerTag
        else
          gamerTag = tr.css('td a')[1]['aria-label'].strip
          gamerTag = gamerTag.gsub(' (invitation pending)', '').strip
          gamerTag = gamerTag.split('|')[1].strip if gamerTag.split('|').length > 1
          if firstGamerTag != gamerTag
            # try to create an AlternativeGamerTag if the firstGamerTag doesn't match the second
            player = Player.find_by(gamer_tag: gamerTag)
            AlternativeGamerTag.create(player_id: player.id, gamer_tag: firstGamerTag, country_code: 'uk') unless player.nil?
          end
        end
        # check if this player doesn't exists in the db
        if !allGamerTags.include?(gamerTag)
          puts 'Player: ' + gamerTag + ' not found!'
          if !notFoundPlayers.include?(gamerTag)
            notFoundPlayers << gamerTag
          end
          next #continue
        end
        # check if this players result was already added to this tournament
        player = tournament.players.find_by(gamer_tag: gamerTag)
        if player.nil?
          alt = AlternativeGamerTag.find_by(gamer_tag: gamerTag)
          player = alt.player unless alt.nil?
        end
        if player.nil?
          puts 'Player: "' + gamerTag + '" is nil for some reason! <====================='
          puts 'tournament.players:'
          puts tournament.players.map{|p| p.gamer_tag}
          puts '---'
          next  # continue
        end
        if (tournament.results.map {|r| r.player_id}).include?(player.id)
          puts player.gamer_tag + 's result was already added -> continue with the next result'
          next  # continue
        end
        # create a new result
        result = Result.new
        result.player = Player.find_by(gamer_tag: player.gamer_tag)
        result.tournament = tournament
        if tournament.name.include?('Weekly')
          # # tournament is a weekly -> check if we know it's city
          # result.city = '?'
          # tournament.name.split(' ').each do |word|
          #   if tournament_cities().include?(word)
          #     result.city = word
          #     break
          #   end
          # end
        else
          result.major_name = tournament.name
        end
        result.rank = tr.css('td')[0].text.strip.to_i
        result.points = points_repartition_table(result.rank)
        result.wins = tr.css('td')[5].text.strip.to_i # wins
        result.losses = tr.css('td')[7].text.strip.to_i # losses
        if result.save
          puts "-> Created result for: \"" + player.gamer_tag + "\""
          # update player
          player.points += result.points
          player.participations += 1
          if result.rank.present? and (player.best_rank == 0 or result.rank < player.best_rank) then player.best_rank = result.rank end
          player.wins += result.wins
          player.losses += result.losses
          player.country_code = 'uk'
          player.save! # raise an exception when player.save failed
          player.update_tournament_experience
          # update the tournament ranking string
          if !tournament.ranking_string.to_s.include?(player.gamer_tag)
            rs = "#{result.rank.to_s},#{player.gamer_tag};"
            tournament.update(ranking_string: tournament.ranking_string.to_s + rs)
          end
        else
          puts "-> Result for: \"" + result.name + "\" couldn't be saved!"
          if result.errors.any?
            result.errors.full_messages.each do |message|
              puts "==> " + message
            end
            puts "\n"
          end
        end
      end

    end
  end

end
