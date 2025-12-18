require 'nokogiri'
require 'open-uri'

namespace :tournaments_crawler_us_ca do
  desc "Calls all the tournaments web crawler tasks"
  task all: :environment do
    tCtr = Tournament.all_from('us_ca').count
    puts "Running all tournaments web crawlers..."
    [
      "tournaments_crawler_us_ca:braacket",
      "tournaments_crawler_us_ca:smash_gg"
    ].each do |task_name|
      begin
        Rake::Task[task_name].reenable
        Rake::Task[task_name].invoke
      rescue => e
        puts "Task #{task_name} failed: #{e.class} - #{e.message}"
        Rails.logger.error e.full_message
      end
    end
    puts "\ndone -> #{Tournament.all_from('us_ca').count - tCtr} new tournament(s)\n"
  end

  desc "Creates upcoming external tournaments from braacket.com"
  task braacket: :environment do
    Time.use_zone("Pacific Time (US & Canada)") {
      puts 'Crawling https://braacket.com/tournament...'
      root = 'https://braacket.com'
      doc = Nokogiri::HTML(URI.open('https://braacket.com/tournament/search?rows=100&country=us&country_region=california&game=ssbu&status=1'))
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
        externalTournament.country_code = 'us_ca'
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
    }
  end

  desc "Creates upcoming external tournaments from start.gg"
  task smash_gg: :environment do
    Time.use_zone("Pacific Time (US & Canada)") {
      puts 'Crawling https://start.gg/tournaments...'
      root = 'https://start.gg/'

      # URL to get the data as JSON
      # doc = Nokogiri::HTML(URI.open('https://start.gg/api/-/gg_api./public/tournaments/schedule?filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A%221386%22%2C%22countryCode%22%3A%22US%22%2C%22addrState%22%3A%22CA%22}&page=1&per_page=100&returnMeta=true'))
      doc = URI.open('https://start.gg/api/-/gg_api./public/tournaments/schedule?filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A%221386%22%2C%22countryCode%22%3A%22US%22%2C%22addrState%22%3A%22CA%22}&page=1&per_page=100&returnMeta=true').read
      jsonHash = JSON.parse doc
      ([jsonHash['total_count'], 100].min).times do |i|
        tournamentHash = jsonHash['total_count'] == 1 ? jsonHash['items']['entities']['tournament'] : jsonHash['items']['entities']['tournament'][i]
        externalTournament = Tournament.find_by(smash_gg_id: tournamentHash['id'])
        externalTournament = Tournament.find_by(name: tournamentHash['name']) if externalTournament.nil?
        externalTournament = Tournament.new if externalTournament.nil?
        externalTournament.smash_gg_id = tournamentHash['id']
        externalTournament.subtype = 'external'
        externalTournament.date = Time.at(tournamentHash['startAt']) rescue nil
        isDateError = false
        if externalTournament.date.nil? || externalTournament.date < Date.yesterday
          externalTournament.date = Date.today
          isDateError = true
        end
        externalTournament.end_date = Time.at(tournamentHash['endAt']) rescue nil
        externalTournament.name = tournamentHash['name']
        externalTournament.external_registration_link = root + tournamentHash['slug']
        externalTournament.city = tournamentHash['city']
        externalTournament.location = tournamentHash['venueAddress']
        externalTournament.is_registration_allowed = false
        externalTournament.active = true
        externalTournament.country_code = 'us_ca'
        new_record = externalTournament.new_record?
        if externalTournament.save
          puts "-> #{new_record ? "Created" : "Updated"}: \"#{externalTournament.name}\""
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
    }
  end

end
