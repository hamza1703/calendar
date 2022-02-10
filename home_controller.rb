require 'date'
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

  
  def controls input
    
    case input
      when "1" then
        date = Home.input_date
        return if date == false
        details = Home.input_event_detail
        puts @calendar.add_event(date,details)
      when "2" then
        date = Home.input_date
        return if date == false
        puts @calendar.remove_event(date)
      when "3" then
        date = Home.input_date
        return if date == false
        puts @calendar.update_event(date)
      when "4" then
        date = Home.input_date
        return if date == false
        @calendar.view_events date
      when "5" then
        date = Home.input_date
        return if date == false
        @calendar.grid_view date
      when "6" then
        date = Home.input_date
        return if date == false
        @calendar.month_view date
        
      else puts "Please type the correct option"
    end
  end


end

controller = HomeController.new
