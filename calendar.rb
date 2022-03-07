require "date"
require_relative "event"
require_relative "home"

class Calendar
  attr_accessor :events

  def initialize
    @events = Hash.new { |h, k| h[k] = [] }
    load_data_from_file
  end

  def load_data_from_file
    File.foreach("events.txt") do |line|
      date_from_file, details_from_file = line.split(",")
      event_data = Event.new(Date.parse(date_from_file), details_from_file.chomp)
      @events[event_data.date.month].push(event_data)
    end
  end

  def get_matched_event_line_numbers_from_file(file, date)
    count = 0
    arr = []
    File.open(file, "r") { |file|
      file.each_line { |line|
        arr << count if line =~ /#{date}/
        count += 1
      }
    }
    arr
  end

  def add_event(date, details)
    event_to_add = Event.new(date, details)
    @events[date.month].push(event_to_add)
    File.open("events.txt", "a") { |f| f.write "#{event_to_add.date},#{event_to_add.details}\n" }
    puts "Successfully added an event"
  end

  def view_events_of_specified_date(date)
    verify_event_date = File.read("events.txt").include?(date.to_s)
    event_line_number_in_file = get_matched_event_line_numbers_from_file("events.txt", date.to_s)
    verify_event_date ? event_line_number_in_file.each { |line| puts File.read("events.txt").lines[line] } : puts("event does not exist")
  end

  def grid_view(date)
    start_weekday = date.cwday
    day_events = Hash.new(0)
    @events[date.month].each { |event| day_events[event.date.day] += 1 if event.date.year == date.year }
    Home.grid_view(start_weekday, day_events)
  end

  def month_view(date)
    if @events[date.month].empty?
      puts "No events for this month."
      return nil
    end

    puts "Events for the month #{Date::MONTHNAMES[date.month]}"

    filtered_events = @events[date.month].select { |event| event.date.year == date.year }
    Home.show_events(filtered_events)
  end

  def remove_event(date)
    matched_event_line_numbers = get_matched_event_line_numbers_from_file("events.txt", date.to_s)
    line_number_of_selected_event_to_remove = Home.show_list_of_events_and_select_one(matched_event_line_numbers)
    remove(date, matched_event_line_numbers, line_number_of_selected_event_to_remove)
  end

  def update_event(date)
    matched_event_line_numbers = get_matched_event_line_numbers_from_file("events.txt", date.to_s)
    line_number_of_selected_event_to_update = Home.show_list_of_events_and_select_one(matched_event_line_numbers)
    event_details_to_update = Home.input_event_detail
    update(date, matched_event_line_numbers, line_number_of_selected_event_to_update, event_details_to_update)
  end

  private

  def remove(date, matched_event_line_numbers, line_number_of_selected_event_to_remove)
    if matched_event_line_numbers.include? matched_event_line_numbers[line_number_of_selected_event_to_remove.to_i] #checks if the input number matches the event that will be updated
      all_events_line_numbers = File.readlines("events.txt")
      all_events_line_numbers[matched_event_line_numbers[line_number_of_selected_event_to_remove.to_i]] = "" #removes the event details on selected line number
      File.open("events.txt", "w") { |f| f.write(all_events_line_numbers.join) }
      puts "Successfully removed"
      load_data_from_file
    else
      puts "Incorrect option"
    end
  end

  def update(date, matched_event_line_numbers, line_number_of_selected_event_to_update, event_details_to_update)
    if matched_event_line_numbers.include? matched_event_line_numbers[line_number_of_selected_event_to_update.to_i] #checks if the input number matches the event that will be updated
      all_events_line_numbers = File.readlines("events.txt")
      all_events_line_numbers[matched_event_line_numbers[line_number_of_selected_event_to_update.to_i]] = "#{date},#{event_details_to_update}\n"  #updates the event details on selected line number
      File.open("events.txt", "w") { |f| f.write(all_events_line_numbers.join) }
      puts "Successfully updated"
      load_data_from_file
    else
      puts "Incorrect option"
    end
  end
end
