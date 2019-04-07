require 'nokogiri'
require 'open-uri'

namespace :sniffer do
  desc "Calls all sniffer tasks"
  task all: :environment do
    Rake::Task["sniffer:braacket"].invoke
    Rake::Task["sniffer:smash_gg"].invoke
    Rake::Task["sniffer:toornament"].invoke
    puts "\n"
    puts "done"
  end

  desc "Creates upcomming external tournaments from braacket.com"
  task braacket: :environment do
    puts 'Sniffing https://braacket.com/tournament...'
    root = 'https://braacket.com'
    doc = Nokogiri::HTML(open('https://braacket.com/tournament/search?rows=100&country=ch&game=ssbu&status=1'))
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

  desc "Creates upcomming external tournaments from smash.gg"
  task smash_gg: :environment do
    puts 'Sniffing https://smash.gg/tournaments...'
    root = 'https://smash.gg'
    doc = Nokogiri::HTML(open('https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22CH%22}'))
    doc.css('div.gg-component-reset.TournamentCard').each_with_index do |c, i|
      # each tournament card (c)
      externalTournament = Tournament.new
      externalTournament.subtype = 'external'
      infoSpans = c.css('div.TournamentCardHeading__information span')
      externalTournament.date = Date.parse(infoSpans[infoSpans.count-1].text)
      isDateError = false
      if externalTournament.date < Date.yesterday
        externalTournament.date = Date.tomorrow
        isDateError = true
      end
      titleAnchor = c.css('div.TournamentCardHeading__title a')[0]
      externalTournament.name = titleAnchor.text
      externalTournament.external_registration_link = root + titleAnchor['href']
      externalTournament.city = c.css('div.InfoList span')[1].text unless c.css('div.InfoList span')[1].nil?
      externalTournament.active = true
      if externalTournament.save
        puts "-> Created: \"" + externalTournament.name + "\""
        if isDateError
          puts '=> Invalid date! You have to edit the date manually!'
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
  end

  desc "Creates upcomming external tournaments from toornament.com"
  task toornament: :environment do
    puts 'Sniffing https://www.toornament.com/tournaments...'
    root = 'https://toornament.com'
    validFlag = 'flag-ch'
    doc = Nokogiri::HTML(open('https://www.toornament.com/tournaments/?q[discipline]=supersmashbros_ultimate&q[platform]=nintendo_switch&q[type]=upcoming'))
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
