require "./src/working_hours.cr"

working_hours = WorkingHours.new
sign = working_hours.sign
time = working_hours.time

message = if sign == "+"
  "Excellent! You can rest :)"
else
  "Sad. You have to work harder :("
end

puts "---------------\n"

puts "#{message}\n"
puts "time: #{sign}#{time}\n"
