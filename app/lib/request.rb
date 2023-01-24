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

end
