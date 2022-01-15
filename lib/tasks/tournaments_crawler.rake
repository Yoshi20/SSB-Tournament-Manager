require 'nokogiri'
require 'open-uri'

namespace :tournaments_crawler do
  desc "Calls all the tournaments web crawler tasks"
  task all: :environment do
    tCtr = Tournament.all_ch.count
    puts "Running all tournaments web crawlers..."
    Rake::Task["tournaments_crawler:braacket"].invoke
    Rake::Task["tournaments_crawler:smash_gg"].invoke
    Rake::Task["tournaments_crawler:toornament"].invoke
    puts "\ndone -> #{Tournament.all_ch.count - tCtr} new tournament(s)\n"
  end

  desc "Creates upcoming external tournaments from braacket.com"
  task braacket: :environment do
    puts 'Crawling https://braacket.com/tournament...'
    root = 'https://braacket.com'
    doc = Nokogiri::HTML(URI.open('https://braacket.com/tournament/search?rows=100&country=ch&game=ssbu&status=1'))
    doc.css('div.my-panel-mosaic').each_with_index do |p, i|
      # each tournament panel (p)
      externalTournament = Tournament.new
      externalTournament.subtype = 'external'
      externalTournament.date = Date.parse(p.css("div.my-dashboard-values-sub")[3].css('div')[1].text)
      p.css('div.panel-heading a').each do |a|
        externalTournament.name = a.text.strip unless a.text.strip.empty?
      end
      externalTournament.city = ''
      p.css('div.panel-heading td.ellipsis').each do |td|
        td.css('a').each do |a|
          externalTournament.external_registration_link = root + a['href']
        end
      end
      seatsString = p.css("div.my-dashboard-values-sub")[4].css('div')[2].text.strip
      # externalTournament.occupied_seats = seatsString[0...seatsString.index('/')].to_i
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

  desc "Creates upcoming external tournaments from smash.gg"
  task smash_gg: :environment do
    puts 'Crawling https://smash.gg/tournaments...'
    root = 'https://smash.gg/'

    # URL to get the data as JSON
    doc = Nokogiri::HTML(URI.open('https://smash.gg/api/-/gg_api./public/tournaments/schedule?filter={"upcoming"%3Atrue%2C"videogameIds"%3A"1386"%2C"countryCode"%3A"CH"}&page=1&per_page=100&returnMeta=true'))
    jsonHash = JSON.parse doc
    jsonHash['total_count'].times do |i|
      tournamentHash = jsonHash['items']['entities']['tournament'][i]
      externalTournament = Tournament.new
      externalTournament.subtype = 'external'
      externalTournament.date = Time.at(tournamentHash['startAt']).to_date rescue nil
      isDateError = false
      if externalTournament.date.nil? || externalTournament.date < Date.yesterday
        externalTournament.date = Date.today
        isDateError = true
      end
      externalTournament.name = tournamentHash['name']
      externalTournament.external_registration_link = root + tournamentHash['slug']
      externalTournament.city = tournamentHash['city']
      externalTournament.location = tournamentHash['venueAddress']
      externalTournament.is_registration_allowed = false
      externalTournament.active = true
      if externalTournament.save
        puts "-> Created: \"" + externalTournament.name + "\""
        if isDateError
          puts '==> Invalid date! You have to edit the date manually!'
          TournamentMailer.with(tournament: externalTournament).invalid_date_email.deliver_later
        end
        puts "\n"
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

    # URL to get the data as web page
    # doc = Nokogiri::HTML(URI.open('https://smash.gg/tournaments?per_page=100&filter=%7B%22upcoming%22%3Atrue%2C%22videogameIds%22%3A1386%2C%22countryCode%22%3A%22CH%22%7D'))
    # doc.css('div.TournamentCard').each_with_index do |c, i|
    #   # each tournament card (c)
    #   externalTournament = Tournament.new
    #   externalTournament.subtype = 'external'
    #   infoSpans = c.css('div.TournamentCardHeading__information span')
    #   externalTournament.date = Date.parse(infoSpans[infoSpans.count-1].text) rescue nil
    #   isDateError = false
    #   if externalTournament.date.nil? || externalTournament.date < Date.yesterday
    #     externalTournament.date = Date.today
    #     isDateError = true
    #   end
    #   titleAnchor = c.css('div.TournamentCardHeading__title a')[0]
    #   externalTournament.name = titleAnchor.text
    #   externalTournament.external_registration_link = root + titleAnchor['href']
    #   externalTournament.city = c.css('div.InfoList span')[1].text unless c.css('div.InfoList span')[1].nil?
    #   externalTournament.is_registration_allowed = false
    #   externalTournament.active = true
    #   if externalTournament.save
    #     puts "-> Created: \"" + externalTournament.name + "\""
    #     if isDateError
    #       puts '==> Invalid date! You have to edit the date manually!'
    #       TournamentMailer.with(tournament: externalTournament).invalid_date_email.deliver_later
    #     end
    #     puts "\n"
    #   else
    #     puts "-> \"" + externalTournament.name + "\" couldn't be saved!"
    #     if externalTournament.errors.any?
    #       externalTournament.errors.full_messages.each do |message|
    #         puts "==> " + message
    #       end
    #       puts "\n"
    #     end
    #   end
    # end
  end

  desc "Creates upcoming external tournaments from toornament.com"
  task toornament: :environment do
    puts 'Crawling https://www.toornament.com/tournaments...'
    root = 'https://toornament.com'
    validFlag = 'flag-ch'
    doc = Nokogiri::HTML(URI.open('https://www.toornament.com/tournaments/?q[discipline]=supersmashbros_ultimate&q[platform]=nintendo_switch&q[type]=upcoming'))
    doc.css('div.tournament-list a.tournament').each_with_index do |a, i|
      locationItalic = a.css('div.event div.location i')[0]
      if !locationItalic.nil? and locationItalic['class'].include?(validFlag)
        # we have a valid tournament
        externalTournament = Tournament.new
        externalTournament.subtype = 'external'
        externalTournament.date = Date.parse(a.css('div.event div.dates time').text.strip)
        externalTournament.name = a.css('div.identity div.name').text.strip
        externalTournament.city = a.css('div.event div.location span').text.strip
        externalTournament.external_registration_link = root + a['href']
        size = a.css('div.size div.number').text.strip
        if size.include?('/')
          size = size[size.index('/')+1..-1].strip.to_i
        else
          size = size.to_i
        end
        externalTournament.total_seats = size
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
  end

end
