# frozen_string_literal: true

module Immobilienscout
  module API
    class Report
      class << self
        def retrieve(is24_id, date_from, date_to)
          raise ArgumentError unless is24_id.present? && date_from.present? && date_to.present?

          query_params = query_params(date_from, date_to)
          url = retrieve_url(is24_id)

          execute_get_request(url, query_params)
        end

        private

        def execute_get_request(url, query_params)
          parsed_response = Immobilienscout::Request.new(url, query_params).get
          Immobilienscout::RequestErrorHandler.handle(parsed_response) unless parsed_response.success?

          parsed_response
        end

        def query_params(date_from, date_to)
          {
            dateFrom: date_from.to_s,
            dateTo: date_to.to_s
          }
        end

        def retrieve_url(is24_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}/dailyreport"
        end
      end
    end
  end
end
