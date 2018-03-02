require "http/client"
require "json"
require "./config.cr"

class Hubstaff
  def fetch_time
    config = Config.new.call
    start_date = Time.parse(config.start_date, "%F")
    end_date = Time.parse(config.end_date, "%F")

    uri = URI.parse("https://api.hubstaff.com/v1/custom/by_project/my?start_date=#{start_date.to_s("%Y-%m-%d")}&end_date=#{end_date.to_s("%Y-%m-%d")}")
    headers = HTTP::Headers {
      "App-Token" => config.app_token,
      "Auth-Token" => config.auth_token,
    }

    response = HTTP::Client.get(uri, headers)

    if response.status_code != 200
      puts "http error"
      exit
    end

    JSON.parse(response.body)["organizations"].first["duration"].to_s.to_i
  end
end
