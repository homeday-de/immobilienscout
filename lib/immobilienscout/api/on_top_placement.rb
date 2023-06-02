# frozen_string_literal: true

module Immobilienscout
  module API
    module OnTopPlacement
      PLACEMENT_TYPES = [
        :showcase_placement, # Schaufenster-Platzierung
        :premium_placement,  # Premium-Platzierung
        :top_placement       # Top-Platzierung
      ].freeze

      class << self
        def add(is24_id, placement_type)
          raise ArgumentError unless valid_arguments?(is24_id, placement_type)

          add_url = url(is24_id, placement_type_for_is24(placement_type))
          execute_post_request(add_url)
        end

        def show(is24_id, placement_type)
          raise ArgumentError unless valid_arguments?(is24_id, placement_type)

          show_url = url(is24_id, placement_type_for_is24(placement_type))
          execute_get_request(show_url)
        end

        def delete(is24_id, placement_type)
          raise ArgumentError unless valid_arguments?(is24_id, placement_type)

          destroy_url = url(is24_id, placement_type_for_is24(placement_type))
          execute_delete_request(destroy_url)
        end

        private

        def valid_arguments?(is24_id, placement_type)
          return false unless is24_id.present?
          return false unless placement_type.present? && PLACEMENT_TYPES.include?(placement_type)
          return false unless placement_type_for_is24(placement_type).present?

          true
        end

        def placement_type_for_is24(placement_type)
          {}.tap { |hash| PLACEMENT_TYPES.each { |t| hash[t] = t.to_s.delete('_') } }[placement_type]
        end

        def url(is24_id, placement_type)
          "#{Immobilienscout::Client.api_url}/restapi/api/offer/v1.0/user/me/realestate/#{is24_id}/#{placement_type}"
        end

        def execute_post_request(url)
          parsed_response = Immobilienscout::Request.new(url).post
          Immobilienscout::RequestErrorHandler.handle(parsed_response) unless parsed_response.success?

          parsed_response
        end

        def execute_delete_request(url)
          parsed_response = Immobilienscout::Request.new(url).delete
          Immobilienscout::RequestErrorHandler.handle(parsed_response) unless parsed_response.success?

          parsed_response
        end

        def execute_get_request(url)
          parsed_response = Immobilienscout::Request.new(url).get
          Immobilienscout::RequestErrorHandler.handle(parsed_response) unless parsed_response.success?

          parsed_response
        end
      end
    end
  end
end
