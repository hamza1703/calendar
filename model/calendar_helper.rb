module CalendarHelper
	def CalendarHelper.input_date
		puts "Enter date : dd/mm/yyyy"
		date = Date.parse(gets.chomp)
	end
end
