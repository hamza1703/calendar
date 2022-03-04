class Event
  attr_accessor :date, :details

  def initialize(date, details)
    @date = date
    @details = details
  end
end
