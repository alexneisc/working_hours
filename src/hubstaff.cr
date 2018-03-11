require "http/client"
require "json"
require "./config.cr"

class Hubstaff
  @config : Config::YamlObject

  def initialize(start_date : Time, end_date : Time)
    @config = Config.new.call
    @start_date = start_date
    @end_date = end_date
  end

  def call
    split_into_periods(@start_date, @end_date)
  end

  private def split_into_periods(start_date, end_date)
    difference_in_days = (end_date - start_date).days
    full_31_days, _ = difference_in_days.divmod(31)

    part_end_date = start_date - 1.day
    worked_seconds = 0

    i = 1
    while i <= full_31_days
      part_start_date = start_date + (31 * (i - 1)).days
      part_end_date = start_date + (31 * i).days - 1.day
      worked_seconds += fetch_worked_seconds(part_start_date, part_end_date)
      i += 1
    end

    part_start_date = part_end_date + 1.day

    worked_seconds += fetch_worked_seconds(part_start_date, end_date)
  end

  private def fetch_worked_seconds(start_date, end_date)
    puts "Fetch work time for period between #{start_date.to_s("%Y-%m-%d")} and #{end_date.to_s("%Y-%m-%d")}\n"

    uri = URI.parse("https://api.hubstaff.com/v1/custom/by_project/my?start_date=#{start_date.to_s("%Y-%m-%d")}&end_date=#{end_date.to_s("%Y-%m-%d")}")
    headers = HTTP::Headers {
      "App-Token" => @config.app_token,
      "Auth-Token" => @config.auth_token,
    }

    response = HTTP::Client.get(uri, headers)

    if response.status_code != 200
      puts "http error #{response.status_code}\n"
      exit
    end

    body = JSON.parse(response.body)

    if body["organizations"].size > 0
      JSON.parse(response.body)["organizations"].first["duration"].to_s.to_i
    else
      0
    end
  end
end
