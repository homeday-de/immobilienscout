module Immobilienscout
  class ResponseParser
    HTTP_OK = %w(200 201).freeze

    Message = Struct.new(:success?, :code, :messages, :id)

    def initialize(response)
      @response = response

      raise ArgumentError unless valid?
    end

    private

    def valid?
      @response.present?
    end

    def success?
      HTTP_OK.include? @response.code
    end

    def code
      @response.code
    end

    def messages(response_body)
      return response_body unless response_body['common.messages']

      messages = response_body['common.messages'].first['message']
      messages = [messages] if messages.is_a? Hash
      messages.map { |msg| Message.new(nil, msg['messageCode'], msg['message'], msg['id']) }
    end

    def id(response_body)
      return unless response_body['common.messages']

      messages = response_body['common.messages'].first['message']
      messages['id'] if messages.is_a? Hash
    end

    def assign_response_body
      JSON.parse(@response.body)
    rescue JSON::ParserError
      JSON.parse(Hash.from_xml(@response.body).to_json)
    end
  end
end
