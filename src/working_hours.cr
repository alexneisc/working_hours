require "./hubstaff.cr"

class WorkingHours
  @should_worked_seconds : Int32
  @real_worked_seconds : Int32

  def initialize(start_date : Time, end_date : Time, days_off : Array(Time))
    should_worked_days = business_days_between(start_date, end_date, days_off)
    @should_worked_seconds = should_worked_days * 6 * 60 * 60
    @real_worked_seconds = Hubstaff.new(start_date, end_date).call
  end

  def time
    hours, minutes, seconds = calculate_time(@real_worked_seconds, @should_worked_seconds)

    time = beautify_time(hours, minutes, seconds)

    return time
  end

  def sign
    if @should_worked_seconds > @real_worked_seconds
      "-"
    else
      "+"
    end
  end

  def message
    if @should_worked_seconds > @real_worked_seconds
      "Sad. You have to work harder :("
    else
      "Excellent! You can rest :)"
    end
  end

  private def business_days_between(start_date, end_date, days_off)
    business_days = 0
    date = end_date
    while date >= start_date
      unless date.saturday? || date.sunday? || days_off.includes?(date)
        business_days = business_days + 1
      end

      date = date - 1.day
    end
    business_days
  end

  private def calculate_time(real_worked_seconds, should_worked_seconds)
    if should_worked_seconds > real_worked_seconds
      lost_seconds = should_worked_seconds - real_worked_seconds
    else
      lost_seconds = real_worked_seconds - should_worked_seconds
    end

    hours = lost_seconds / (60 * 60)
    minutes = (lost_seconds / 60) % 60
    seconds = lost_seconds % 60

    return hours, minutes, seconds
  end

  private def beautify_time(hours, minutes, seconds)
    if minutes < 10
      minutes = "0#{minutes}"
    end

    if seconds < 10
      seconds = "0#{seconds}"
    end

    "#{hours}:#{minutes}:#{seconds}"
  end
end
