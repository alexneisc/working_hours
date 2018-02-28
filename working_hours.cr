require "./src/config.cr"
require "./src/working_hours.cr"

start_date = Time.new(2018, 2, 1)
end_date = Time.now

working_hours = WorkingHours.new(start_date, end_date)
sign = working_hours.sign
time = working_hours.time

message = if sign == "+"
  "Excellent! You can rest :)"
else
  "Sad. You have to work harder :("
end

puts message
puts "time: #{sign}#{time}"
