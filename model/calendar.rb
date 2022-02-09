require 'date'
require_relative 'calendar_helper'
require_relative 'event'
require_relative '../view/home'

class Calendar
	attr_accessor :events
	include CalendarHelper
	def initialize
    	@events = Hash.new { |h, k| h[k] = [] }
    	load_data
  	end

  	def load_data
		file_data = File.open("events.txt");
		File.foreach("events.txt") do |line|
			date_from_file, details_from_file = line.split(',')
			event_data = Event.new(Date.parse(date_from_file),details_from_file.chomp)
			@events[event_data.date.month].push(event_data)
		end
	end


	#this method returns the matched events line numbers in an array
	def get_line_number(file, date)
		count = 0
		arr = []
		file = File.open(file, "r") { |file| file.each_line { |line|
	    	arr << count if line =~ /#{date}/
	    	count += 1

	  		}
		}
	  arr
	end

	def add_event
		date = CalendarHelper.input_date
		puts "Enter event details"
		details = gets.chomp
		event_to_add = Event.new(date,details)
		@events[date.month].push(event_to_add)
		# puts @events
		File.open("events.txt", "a") { |f| f.write "#{event_to_add.date},#{event_to_add.details}\n" }
		puts "Successfully added an event"
	end

	#this method displays events of specified date
	
	def view_events
		date = CalendarHelper.input_date
		verify = File.read("events.txt").include?(date.to_s)
		
		line_numbers = get_line_number("events.txt",date.to_s)
		verify ? line_numbers.each {|line| puts File.read("events.txt").lines[line]} : puts("event does not exist")
		[date,verify,line_numbers]
	end

	def grid_view
	    date = CalendarHelper.input_date
	    start_weekday = date.cwday
	    day_events = Hash.new(0)
	    @events[date.month].each { |event| day_events[event.date.day] += 1 if event.date.year == date.year }
	    # puts day_events
	    Home.grid_view(start_weekday, day_events)
  	end

  	def month_view
	    date = CalendarHelper.input_date

	    if @events[date.month].empty?
	      puts 'No events for this month.'
	      return nil
	    end

	    puts "Events for the month #{Date::MONTHNAMES[date.month]}"

	    filtered_events = @events[date.month].select { |event| event.date.year == date.year }
	    # puts filtered_events
	    Home.show_events(filtered_events)
  end

	# ([12]\d{3}-(03)-(0[1-9]|[12]\d|3[01]))
	#this method updates or removes an event based on the input paramter
	def remove_or_update_event(param)
		date, verify, line_numbers = view_events
		count = 0;
		for line in line_numbers do
			puts "type #{count} to #{param == "edit" ? "edit" : "remove"} #{File.read("events.txt").lines[line]}"
			count +=1
		end
		line_num = gets #user selects the event that needs to be updated
		if line_numbers.include?line_numbers[line_num.to_i] #checks if the input number matches the event that will be updated
			if param == "edit"
				puts "Enter Event Details to replace with #{File.read("events.txt").lines[line_numbers[line_num.to_i]]}" #takes event details from user to update
			    event_details = gets.chomp
			end
			lines = File.readlines("events.txt")
			lines[line_numbers[line_num.to_i]] = param == "edit" ? "#{date},#{event_details}\n" : "" #updates/removes the event details on selected line number
			File.open('events.txt', 'w') { |f| f.write(lines.join) }
			puts "Successfully #{param == "edit" ? "modified" : "removed"}"
		else
			puts "Incorrect option"
		end
	end

	def remove_event
		remove_or_update_event "remove"
	end

	def update_event
		remove_or_update_event "edit"
	end

end