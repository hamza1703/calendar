require_relative("validation")

class Home
  include Validation

  def self.view_menu
    puts "1. Add an event\n2. Remove an event\n3. Edit an event\n4. Display an event\n5. Show month view\n6. Event details of month "
  end

  def self.input_date
    puts "Enter date : dd/mm/yyyy"
    date = gets.chomp
    if Validation.date_input_validation(date)
      return Date.parse(date)
    else
      puts "incorrect date"
      exit
    end
  end

  def self.input_event_detail
    puts "Enter event details"
    details = gets.chomp
  end

  def self.show_list_of_events_and_select_one(matched_event_line_numbers)
    count = 0
    for event_line_number in matched_event_line_numbers
      puts "type #{count} to modify/delete #{File.read("events.txt").lines[event_line_number]}"
      count += 1
    end
    gets #user selects the event that needs to be updated or removed
  end

  def self.show_events(events)
    events.each_with_index do |event, index|
      puts "-" * 15
      puts "Event Number #{index + 1}"
      puts "Title:---#{event.details}"
      puts "Date:---#{event.date}"
    end
  end

  def self.grid_view(start_of_month_weekday, event_entries)
    days = %w[M T W T F S S]
    days.each { |d| print format("%-9s", "#{d} ") }
    number_of_days = 0
    day_of_month = start_of_month_weekday
    day = 1
    counter = 7
    while number_of_days < 30 + start_of_month_weekday
      puts if (counter % 7).zero?
      if number_of_days < day_of_month - 1
        print " ".ljust(9)
        counter += 1
      else
        print "#{day}(#{event_entries[day]})".ljust(9) if event_entries[day].positive?
        print day.to_s.ljust(9) if event_entries[day].zero?
        counter += 1
        day += 1
      end
      number_of_days += 1
    end
    puts
  end
end
