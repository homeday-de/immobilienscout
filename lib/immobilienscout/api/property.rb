# frozen_string_literal: true

module Immobilienscout
  module API
    module Property
      class << self
        def create(params)
          raise ArgumentError unless params.present?

          execute_post_request(create_url, params)
        end

        def update(is24_id, params)
          raise ArgumentError unless params.present?

          update_url = update_url(is24_id)

          execute_put_request(update_url, params)
        end

        def publish(params)
          raise ArgumentError unless params.present?

          execute_post_request(publish_url, params)
        end

        def destroy(is24_id)
          raise ArgumentError unless is24_id.present?

          destroy_url = destroy_url(is24_id)

          execute_delete_request(destroy_url)
        end

        def show(is24_id)
          raise ArgumentError unless is24_id.present?

          show_url = show_url(is24_id)

          execute_get_request(show_url)
        end

        private

        def execute_post_request(url, params)
          parsed_response = Immobilienscout::Request.new(url, params).post
          Immobilienscout::RequestErrorHandler.handle(parsed_response) unless parsed_response.success?

          parsed_response
        end

        def execute_put_request(url, params)
          parsed_response = Immobilienscout::Request.new(url, params).put
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

        def create_url
          "#{Immobilienscout::Client.me_url}/realestate"
        end

        def update_url(is24_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}"
        end

        def publish_url
          "#{Immobilienscout::Client.api_url}/restapi/api/offer/v1.0/publish"
        end

        def destroy_url(is24_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}"
        end

        def show_url(is24_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}"
        end
      end
    end
  end
end
