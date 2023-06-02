# frozen_string_literal: true

module Immobilienscout
  class ResponseParser
    HTTP_OK = %w[200 201].freeze

    Message = Struct.new(:success?, :code, :messages, :id)
    PremiumPlacement = Struct.new(:code, :message, :service_period_from, :service_period_to, :external_id)

    def initialize(response)
      @response = response

      raise ArgumentError unless valid?
    end

    def call
      response_body = JSON.parse(@response.body)

      Message.new(success?, code, messages(response_body), id(response_body))
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
      if response_body['common.messages']
        common_message(response_body)
      elsif response_body['premiumplacement.premiumplacements']
        premium_placement(response_body)
      else
        response_body
      end
    end

    def common_message(response_body)
      messages = response_body['common.messages'].first['message']
      messages = [messages] if messages.is_a? Hash
      messages.map { |msg| Message.new(nil, msg['messageCode'], msg['message'], msg['id']) }
    end

    def premium_placement(response_body)
      placements = response_body['premiumplacement.premiumplacements'].first['premiumplacement']
      placements = [placements] if placements.is_a? Hash
      placements.map do |placement|
        PremiumPlacement.new(
          placement['messageCode'], placement['message'], placement['servicePeriod']['dateFrom'],
          placement['servicePeriod']['dateTo'], placement['externalId']
        )
      end
    end

    def id(response_body)
      if response_body['common.messages']
        messages = response_body['common.messages'].first['message']
        messages['id'] if messages.is_a? Hash
      elsif response_body['premiumplacement.premiumplacements']
        placements = response_body['premiumplacement.premiumplacements'].first['premiumplacement']
        placements['@realestateid'] if placements.is_a? Hash
      end
    end
  end
end
