require "date"
require_relative "home.rb"
require_relative "calendar.rb"
require_relative "event.rb"

class HomeController
  def initialize
    @calendar = Calendar.new
    loop do
      Home.view_menu
      input = gets.chomp
      controls(input)
    end
  end

  def get_date
  end

  def controls(input)
    case input
    when "1"
      puts @calendar.add_event(Home.input_date, Home.input_event_detail)
    when "2"
      puts @calendar.remove_event(Home.input_date)
    when "3"
      puts @calendar.update_event(Home.input_date)
    when "4"
      @calendar.view_events_of_specified_date(Home.input_date)
    when "5"
      @calendar.grid_view(Home.input_date)
    when "6"
      @calendar.month_view(Home.input_date)
    else puts "Please type the correct option"
    end
  end
end

HomeController.new
