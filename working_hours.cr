require "http/client"
require "json"
require "./config.cr"

start_date = Time.new(2018, 2, 1)
end_date = Time.now

should_worked_days = business_days_between(start_date, end_date)
should_worked_seconds = should_worked_days * 6 * 60 * 60

real_worked_seconds = get_real_worked_seconds(start_date, end_date)

sign, hours, minutes, seconds = calculate_time(real_worked_seconds, should_worked_seconds)

time = beautify_time(hours, minutes, seconds)

message = if sign == "+"
  "Excellent! You can rest :)"
else
  "Sad. You have to work harder :("
end

puts message
puts "time: #{sign}#{time}"

def business_days_between(date1, date2)
  business_days = 0
  date = date2
  while date > date1
    business_days = business_days + 1 unless date.saturday? || date.sunday?
    date = date - 1.day
  end
  business_days
end

def get_real_worked_seconds(start_date, end_date)
  config = Config.new.call
  uri = URI.parse("https://api.hubstaff.com/v1/custom/by_project/my?start_date=#{start_date.to_s("%Y-%m-%d")}&end_date=#{end_date.to_s("%Y-%m-%d")}")
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

def calculate_time(real_worked_seconds, should_worked_seconds)
  if should_worked_seconds > real_worked_seconds
    lost_seconds = should_worked_seconds - real_worked_seconds
    sign = "-"
  else
    lost_seconds = real_worked_seconds - should_worked_seconds
    sign = "+"
  end

  hours = lost_seconds / (60 * 60)
  minutes = (lost_seconds / 60) % 60
  seconds = lost_seconds % 60

  return sign, hours, minutes, seconds
end


def beautify_time(hours, minutes, seconds)
  if minutes < 10
    minutes = "0#{minutes}"
  end

  if seconds < 10
    seconds = "0#{seconds}"
  end

  "#{hours}:#{minutes}:#{seconds}"
end
