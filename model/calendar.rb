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

	def add_event(date,details)
		
		event_to_add = Event.new(date,details)
		@events[date.month].push(event_to_add)
		# puts @events
		File.open("events.txt", "a") { |f| f.write "#{event_to_add.date},#{event_to_add.details}\n" }
		puts "Successfully added an event"
	end

	#this method displays events of specified date
	
	def view_events(date)
		verify = File.read("events.txt").include?(date.to_s)
		line_numbers = get_line_number("events.txt",date.to_s)
		verify ? line_numbers.each {|line| puts File.read("events.txt").lines[line]} : puts("event does not exist")
	end

	def grid_view(date)
	    start_weekday = date.cwday
	    day_events = Hash.new(0)
	    @events[date.month].each { |event| day_events[event.date.day] += 1 if event.date.year == date.year }
	    # puts day_events
	    Home.grid_view(start_weekday, day_events)
  	end

  	def month_view(date)

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
	

	def remove(date, line_numbers, line_num)
		if line_numbers.include?line_numbers[line_num.to_i] #checks if the input number matches the event that will be updated
			lines = File.readlines("events.txt")
			lines[line_numbers[line_num.to_i]] = "" #removes the event details on selected line number
			File.open('events.txt', 'w') { |f| f.write(lines.join) }
			puts "Successfully removed"
			load_data
			
		else
			puts "Incorrect option"
		end
	end

	def update(date, line_numbers, line_num, modified_event_details)
		if line_numbers.include?line_numbers[line_num.to_i] #checks if the input number matches the event that will be updated
			lines = File.readlines("events.txt")
			lines[line_numbers[line_num.to_i]] ="#{date},#{modified_event_details}\n"  #updates the event details on selected line number
			File.open('events.txt', 'w') { |f| f.write(lines.join) }
			puts "Successfully updated"
			load_data

		else
			puts "Incorrect option"
		end
	end

	def remove_event
		date = Home.input_date
		line_numbers = get_line_number("events.txt",date.to_s)
		line_num = Home.show_list_of_events_and_select_one(line_numbers)
		remove(date, line_numbers, line_num)
	end

	def update_event
		date = Home.input_date
		line_numbers = get_line_number("events.txt",date.to_s)
		line_num = Home.show_list_of_events_and_select_one(line_numbers)
		modified_event_details = Home.input_event_detail
		update(date,line_numbers,line_num,modified_event_details)
	end

end