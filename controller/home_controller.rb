require 'date'
require_relative "../view/home.rb"
require_relative "../model/calendar.rb"
require_relative "../model/event.rb"


class HomeController
	

	def initialize
		@calendar = Calendar.new
		loop do
			Home.view_menu
			input = gets.chomp
			controls(input)
		end
	end

	
	def controls input
		
		case input
			when "1" then
				date = Home.input_date
				details = Home.input_event_detail
				@calendar.add_event(date,details)
			when "2" then
				@calendar.remove_event
			when "3" then
		        @calendar.update_event
			when "4" then
				date = Home.input_date
				@calendar.view_events date
			when "5" then
				date = Home.input_date
				@calendar.grid_view date
			when "6" then
	    		date = CalendarHelper.input_date
				@calendar.month_view date
				
			else puts "Please type the correct option"
		end
	end


end

controller = HomeController.new
