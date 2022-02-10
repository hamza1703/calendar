require('date')

module Validation

  def self.date_input_validation date
    return false if (date =~ %r(^\d{2}/\d{2}/\d{4})).nil? && (date =~ %r(^\d{2}/\d{4})).nil?
    Date.parse(date)
    rescue StandardError
      false
  end
end