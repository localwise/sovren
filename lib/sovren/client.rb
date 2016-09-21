module Sovren
  class Client
    attr_reader :endpoint, :account_id, :service_key

    #Initialize the client class that will be used for all sovren requests.
    #
    # @param [Hash] options
    # @option options String :endpoint The url that the web service is located

    def initialize(account_id, service_key, options={})
      @account_id = account_id
      @service_key = service_key
      @endpoint = options[:endpoint] || 'http://services.resumeparsing.com/ParsingService.asmx?wsdl'
    end

    def connection
      Savon.client(wsdl: @endpoint, log: false)
    end

    def credits_remaining
      account_info[:get_account_info_response][:get_account_info_result][:credits_remaining].to_i
    end

    def credits_used
      account_info[:get_account_info_response][:get_account_info_result][:credits_used].to_i
    end

    def credits_expiration_date
      DateTime.parse( account_info[:get_account_info_response][:get_account_info_result][:expiration_date] )
    end

    #returns resume object
    def parse_resume(file_url)
      fileBuf = open(file_url,"rb") {|io| io.read}
      parsed_resume_results = connection.call(:parse_resume, message: { "request" => account_hash.merge({
                                                                                                          "FileBytes"     => Base64.encode64(fileBuf),
                                                                                                          "OutputHtml"    => true,
                                                                                                          "Configuration" => nil,
                                                                                                          "RevisionDate"  => nil,
                                                                                                        }) }).to_hash[:parse_resume_response][:parse_resume_result]

      Resume.parse(parsed_resume_results)
    end

    private
    
      def account_info
        connection.call(:get_account_info, message: { "request" => account_hash }).body
      end

      def account_hash
        {"AccountId" => @account_id, "ServiceKey" => @service_key}
      end
    
  end
end