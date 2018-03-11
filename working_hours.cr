require "./src/working_hours.cr"

config = Config.new.call
start_date = Time.parse(config.start_date, "%F")
end_date = Time.parse(config.end_date, "%F")

all_time_working_hours = WorkingHours.new(start_date, end_date)
week_working_hours = WorkingHours.new(Time.now.at_beginning_of_week - 1.day, end_date)
today_working_hours = WorkingHours.new(Time.now.at_beginning_of_day, end_date)

puts "---------------\n"
puts "All time working hours:\n"
print_time(all_time_working_hours)

puts "Week working hours:\n"
print_time(week_working_hours)

puts "Today working hours:\n"
print_time(today_working_hours)

def print_time(working_hours)
  sign = working_hours.sign
  time = working_hours.time
  message = working_hours.message

  puts "#{message}\n"
  puts "time: #{sign}#{time}\n"
  puts "---------------\n"
end
