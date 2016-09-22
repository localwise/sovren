module Sovren
  class Education
    attr_accessor :name, :degree, :start_date, :end_date
    
    def self.parse(education_history)
      return Array.new if education_history.nil?
      result = education_history.css('SchoolOrInstitution').collect do |item|
        education = Education.new
        education.name = item.css('SchoolName').text
        education.degree = item.css('Degree DegreeName').text
        education.start_date = Date.parse(item.css('DatesOfAttendance StartDate AnyDate').text) rescue nil
        education.end_date = Date.parse(item.css('DatesOfAttendance EndDate AnyDate').text) rescue nil
        education
      end
      result
    end
  
  end
end