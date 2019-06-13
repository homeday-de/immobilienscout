module Immobilienscout
  module API
    class Attachment
      class << self
        def add(is24_id, binary_file, metadata)
          raise ArgumentError unless is24_id.present? && binary_file.present? && metadata.present?

          url = add_url(is24_id)
          metadata_file = create_metadata_file(metadata)
          params = { attachment: binary_file, metadata: metadata_file }
          parsed_response = Immobilienscout::Request.new(url, params).post_with_multipart

          raise Immobilienscout::Errors::InvalidRequest, parsed_response.messages.map(&:messages) unless parsed_response.success?

          parsed_response
        end

        private

        def create_metadata_file(params)
          metadata_object = StringIO.new(params.to_json)
          UploadIO.new(metadata_object, 'application/json')
        end

        def add_url(is24_id)
          "#{Immobilienscout::Client.api_url}/restapi/api/offer/v1.0/user/me/realestate/#{is24_id}/attachment"
        end
      end
    end
  end
end
