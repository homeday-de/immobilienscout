module Immobilienscout
  module API
    class Report
      class << self
        def retrieve(is24_id, date_from, date_to)
          raise ArgumentError unless is24_id.present? && date_from.present? && date_to.present?

          query_params = query_params(date_from, date_to)
          url = retrieve_url(is24_id)

          parsed_response = Immobilienscout::Request.new(url, query_params).get
          raise Immobilienscout::Errors::InvalidRequest, parsed_response.messages['message']['message'] unless parsed_response.success?

          fix(parsed_response)
        end

        private

        def query_params(date_from, date_to)
          {
            dateFrom: date_from.to_s,
            dateTo: date_to.to_s
          }
        end

        def retrieve_url(is24_id)
          "#{Immobilienscout::Client.api_url}/restapi/api/offer/v1.0/user/me/realestate/#{is24_id}/dailyreport"
        end

        def fix(parsed_response)
          response_array_fixed = place_report_daily_data_in_array(parsed_response)
          convert_numers_from_string_to_integers(response_array_fixed)
        end

        def place_report_daily_data_in_array(parsed_response)
          report_daily_data = parsed_response.messages['dailyReports']['reportDailyData']

          if report_daily_data.is_a? Hash
          parsed_response.messages['dailyReports']['reportDailyData'] = [report_daily_data]
          end

          parsed_response
        end

        def convert_numers_from_string_to_integers(parsed_response)
          parsed_response.messages['dailyReports']['reportDailyData'].map do |hash|
            hash.except('date').map do |key, value|
              hash[key] = value.to_i
            end
          end

          parsed_response
        end
      end
    end
  end
end
