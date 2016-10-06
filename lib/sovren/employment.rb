module Sovren
  class Employment < BaseAdapter
    attr_accessor :employer, :title, :start_date, :end_date
        
    def self.parse(employment_history)
      return Array.new if employment_history.nil?

      result = employment_history.css('EmployerOrg').collect do |item|
        employment = Employment.new
        employment.employer = item.css('EmployerOrgName').text

        if position = item.css('PositionHistory').first
          employment.title = position.css('Title').text
          employment.start_date = Date.parse(position.css('StartDate').text) rescue nil
          employment.end_date = Date.parse(position.css('EndDate').text) rescue nil
        end
        employment
      end
      result
    end
  
  end
end