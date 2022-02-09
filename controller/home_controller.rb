require 'date'
require_relative "../view/home.rb"
require_relative "../model/calendar.rb"
require_relative "../model/event.rb"


class HomeController
	

	def initialize
		@calendar = Calendar.new
		Home.view_menu
		input = gets.chomp
		controls(input)
	end

	
	def controls input
		
		case input
			when "1" then
				@calendar.add_event

			when "2" then
				@calendar.remove_event

			when "3" then
		        @calendar.update_event

			when "4" then
				@calendar.view_events

			when "5" then
				@calendar.grid_view
			when "6" then
				@calendar.month_view
				
			else puts "Please type the correct option"
		end
	end


end

controller = HomeController.new
