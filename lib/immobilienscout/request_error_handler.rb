# frozen_string_literal: true

module Immobilienscout
  module RequestErrorHandler
    class << self
      ERROR_RESOURCE_NOT_FOUND = 'ERROR_RESOURCE_NOT_FOUND'
      ERROR_COMMON_RESOURCE_NOT_FOUND = 'ERROR_COMMON_RESOURCE_NOT_FOUND'
      ERROR_RESOURCE_VALIDATION = 'ERROR_RESOURCE_VALIDATION'

      def handle(parsed_response)
        if parsed_response.messages.is_a?(Array)
          error_code = parsed_response.messages&.first&.code
          error_message = parsed_response.messages.map(&:messages)
        else
          error_code = parsed_response.messages['messageCode']
          error_message = Array.wrap(parsed_response.messages['message'])
        end

        error_class = error_class(error_code)
        raise error_class, error_message
      end

      private

      def error_class(error_code)
        case error_code
        when ERROR_RESOURCE_NOT_FOUND
          Immobilienscout::Errors::ResourceNotFound
        when ERROR_COMMON_RESOURCE_NOT_FOUND
          Immobilienscout::Errors::CommonResourceNotFound
        when ERROR_RESOURCE_VALIDATION
          Immobilienscout::Errors::ResourceValidation
        else
          Immobilienscout::Errors::InvalidRequest
        end
      end
    end
  end
end
