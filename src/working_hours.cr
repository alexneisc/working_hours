require "./hubstaff.cr"

class WorkingHours
  @should_worked_seconds : Int32
  @real_worked_seconds : Int32

  def initialize(start_date : Time, end_date : Time)
    @start_date = start_date
    @end_date = end_date

    should_worked_days = business_days_between(@start_date, @end_date)
    @should_worked_seconds = should_worked_days * 6 * 60 * 60
    @real_worked_seconds = Hubstaff.new(@start_date, @end_date).fetch_time
  end

  def sign
    if @should_worked_seconds > @real_worked_seconds
      "-"
    else
      "+"
    end
  end

  def time
    hours, minutes, seconds = calculate_time(@real_worked_seconds, @should_worked_seconds)

    time = beautify_time(hours, minutes, seconds)

    return time
  end

  private def business_days_between(date1, date2)
    business_days = 0
    date = date2
    while date > date1
      business_days = business_days + 1 unless date.saturday? || date.sunday?
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
