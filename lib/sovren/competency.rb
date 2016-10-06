module Sovren
  class Competency < BaseAdapter
    attr_accessor :name

    def self.parse(competencies)
      return Array.new if competencies.nil?
      results = competencies.css('Competency').collect do |item|
        competency = Competency.new
        competency.name = item['name']
        competency
      end
      results
    end

  end
end