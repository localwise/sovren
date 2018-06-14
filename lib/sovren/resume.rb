require 'json'

module Sovren
  class Resume < ActiveModel::Serializer
    attr_accessor :education_history, :employment_history, :skills, :qualifications, :profile, :parsed_resume_results
                  #:executive_summary, :objective,
                  #:certifications, :competencies, :achievements, :associations, :languages, :military_history, :patent_history,
                  #:publication_history, :references

    def self.parse(parsed_resume_results)
      return nil if parsed_resume_results.nil?

      parsed_resume = Nokogiri::XML.parse(parsed_resume_results[:xml])
      resume = self.new

      resume.parsed_resume_results = parsed_resume_results
      resume.employment_history = Employment.parse(parsed_resume.css('EmploymentHistory').first)
      resume.education_history = Education.parse(parsed_resume.css('EducationHistory').first)
      resume.qualifications = Competency.parse(parsed_resume.css('Qualifications').first)
      resume.skills = resume.qualifications.collect(&:name).uniq rescue []
      resume.profile = ContactInformation.parse(parsed_resume.css('ContactInfo').first)
=begin
      #TODO: create new adapter classes when we know what fields we need
      resume.executive_summary = parsed_resume.css('ExecutiveSummary').text
      resume.objective = parsed_resume.css('Objective').text
      resume.certifications = Certification.parse(parsed_resume.css('LicensesAndCertifications').first)
      resume.achievements = Achievement.parse(parsed_resume.css('Achievements').first)
      resume.associations = Association.parse(parsed_resume.css('Associations').first)
      resume.languages = Language.parse(parsed_resume.css('Languages').first)
      resume.military_history = Military.parse(parsed_resume.css('MilitaryHistory').first)
      resume.patent_history = Patent.parse(parsed_resume.css('PatentHistory').first)
      resume.publication_history = Publication.parse(parsed_resume.css('PublicationHistory').first)
      resume.references = Reference.parse(parsed_resume.css('References').first)
=end
      resume
    end

  end
end
