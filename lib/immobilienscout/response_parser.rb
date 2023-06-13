# frozen_string_literal: true

module Immobilienscout
  class ResponseParser
    HTTP_OK = %w[200 201].freeze

    Message = Struct.new(:success?, :code, :messages, :id)
    OnTopPlacementMessage = Struct.new(:code, :message, :placement_type,
                                       :service_period_from, :service_period_to,
                                       :id, :external_id)

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
      return common_message(response_body) if response_body['common.messages']

      type = on_top_placement_type(response_body)
      return on_top_placement_message(response_body, type) if type

      response_body
    end

    def common_message(response_body)
      messages = response_body['common.messages'].first['message']
      messages = [messages] if messages.is_a? Hash
      messages.map { |msg| Message.new(nil, msg['messageCode'], msg['message'], msg['id']) }
    end

    def on_top_placement_type(response_body)
      return :showcase_placement if response_body['showcaseplacement.showcaseplacements']
      return :premium_placement if response_body['premiumplacement.premiumplacements']
      return :top_placement if response_body['topplacement.topplacements']
    end

    def on_top_placement_message(response_body, placement_type)
      is24_placement_type = Immobilienscout::API::OnTopPlacement.placement_type_for_is24(placement_type)

      placements = extract_placements(response_body, is24_placement_type)
      build_on_top_placement_messages(placements, placement_type)
    end

    def extract_placements(response_body, is24_placement_type)
      placements = response_body["#{is24_placement_type}.#{is24_placement_type.pluralize}"].first[is24_placement_type]
      placements.is_a?(Hash) ? [placements] : placements
    end

    def build_on_top_placement_messages(placements, placement_type)
      placements.map do |placement|
        OnTopPlacementMessage.new(
          placement['messageCode'], placement['message'], placement_type,
          service_period(placement, 'dateFrom'), service_period(placement, 'dateTo'),
          placement['@realestateid'], placement['externalId']
        )
      end
    end

    def service_period(placement, date_key)
      date_string = placement.dig('servicePeriod', date_key)
      date_string ? DateTime.parse(date_string) : nil
    end

    def id(response_body)
      return unless response_body['common.messages']

      messages = response_body['common.messages'].first['message']
      messages['id'] if messages.is_a? Hash
    end
  end
end
