module Request

  require 'open-uri'
  require 'json'
  def self.discord_invite(key)
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

  def self.url_valid?(url)
    begin
      return URI.parse(url).host.present?
    rescue URI::InvalidURIError
      return false
    end
  end

  def self.find_country_code(address)
    country_code = nil
    begin
      json_data = JSON.parse(URI.open("https://maps.googleapis.com/maps/api/geocode/json?address=#{ERB::Util.url_encode(address)}&key=#{ENV['GOOGLE_MAPS_SERVER_SIDE_API_KEY']}&outputFormat=json").read)
      if json_data["status"] == "OK" && json_data["results"].present? && json_data["results"][0].present?
        json_data["results"][0]["address_components"].each do |res|
          if (res["types"].present? && res["types"].include?('country'))
            country_code = res["short_name"].downcase if res["short_name"].present?
          end
        end
      end
    rescue OpenURI::HTTPError => ex
      puts ex
    end
    return country_code
  end

end
