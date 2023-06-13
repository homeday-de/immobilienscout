# frozen_string_literal: true

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

          unless parsed_response.success?
            raise Immobilienscout::Errors::InvalidRequest, parsed_response.messages.map(&:messages)
          end

          parsed_response
        end

        def put_order(is24_id, params)
          raise ArgumentError unless params.present?

          parsed_response = Immobilienscout::Request.new(put_order_url(is24_id), params).put
          unless parsed_response.success?
            raise Immobilienscout::Errors::InvalidRequest, parsed_response.messages.map(&:messages)
          end

          parsed_response
        end

        def retrieve_all(is24_id)
          raise ArgumentError unless is24_id.present?

          url = retrieve_all_url(is24_id)
          parsed_response = Immobilienscout::Request.new(url).get
          Immobilienscout::RequestErrorHandler.handle(parsed_response) unless parsed_response.success?

          parsed_response
        end

        def destroy(is24_id, attachment_id)
          raise ArgumentError unless is24_id.present?
          raise ArgumentError unless attachment_id.present?

          url = destroy_url(is24_id, attachment_id)
          parsed_response = Immobilienscout::Request.new(url).delete
          Immobilienscout::RequestErrorHandler.handle(parsed_response) unless parsed_response.success?

          parsed_response
        end

        private

        def create_metadata_file(params)
          metadata_object = StringIO.new(params.to_json)
          UploadIO.new(metadata_object, 'application/json')
        end

        def add_url(is24_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}/attachment"
        end

        def put_order_url(is24_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}/attachment/attachmentsorder"
        end

        def retrieve_all_url(is24_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}/attachment"
        end

        def destroy_url(is24_id, attachment_id)
          "#{Immobilienscout::Client.me_url}/realestate/#{is24_id}/attachment/#{attachment_id}"
        end
      end
    end
  end
end
