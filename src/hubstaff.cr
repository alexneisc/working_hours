require "http/client"
require "json"

class Hubstaff
  def initialize(start_date : Time, end_date : Time)
    @start_date = start_date
    @end_date = end_date
  end

  def fetch_time
    config = Config.new.call
    uri = URI.parse("https://api.hubstaff.com/v1/custom/by_project/my?start_date=#{@start_date.to_s("%Y-%m-%d")}&end_date=#{@end_date.to_s("%Y-%m-%d")}")
    headers = HTTP::Headers {
      "App-Token" => config["hubstaff"]["app_token"].to_s,
      "Auth-Token" => config["hubstaff"]["auth_token"].to_s,
    }

    response = HTTP::Client.get(uri, headers)
    #
    if response.status_code != 200
      puts "http error"
      exit
    end

    JSON.parse(response.body)["organizations"].first["duration"].to_s.to_i
  end
end
