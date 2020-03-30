# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Immobilienscout::ResponseParser, type: :model do
  describe '#call' do
    context 'when message is present' do
      context 'when response has just one message' do
        let!(:response) { instance_double('Net::HTTPResponse', code: '201', body: { 'common.messages': [{ 'message': { 'messageCode': 'MESSAGE_RESOURCE_CREATED', 'message': 'Resource [realestate] with id [314712920] has been created.', 'id': '314712920' } }] }.to_json) }
        let!(:service) { described_class.new(response) }

        it 'returns messages' do
          parsed_response = service.call

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '201'
          expect(parsed_response.messages.count).to eq 1
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_CREATED'
          expect(parsed_response.messages.first.messages).to eq 'Resource [realestate] with id [314712920] has been created.'
          expect(parsed_response.messages.first.id).to eq '314712920'
        end
      end

      context 'when response has two or more messages' do
        let!(:response) { instance_double('Net::HTTPResponse', code: '412', body: { 'common.messages': [{ 'message': [{ 'messageCode': 'ERROR_RESOURCE_VALIDATION', 'message': 'Error while validating input for the resource. [MESSAGE: numberOfRooms : null : MANDATORY_FIELD_EMPTY]' }, { 'messageCode': 'ERROR_RESOURCE_VALIDATION', 'message': 'Error while validating input for the resource. [MESSAGE: livingSpace : null : MANDATORY_FIELD_EMPTY]' }, { 'messageCode': 'ERROR_RESOURCE_VALIDATION', 'message': 'Error while validating input for the resource. [MESSAGE: title :  : MANDATORY_FIELD_EMPTY]' }, { 'messageCode': 'ERROR_RESOURCE_VALIDATION', 'message': 'Error while validating input for the resource. [MESSAGE: courtageInformation.courtage :  : COURTAGE_EMPTY]' }] }] }.to_json) }
        let!(:service) { described_class.new(response) }

        it 'returns messages' do
          parsed_response = service.call

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq false
          expect(parsed_response.code).to eq '412'
          expect(parsed_response.messages.count).to eq 4
          expect(parsed_response.messages.map(&:messages)).to eq ['Error while validating input for the resource. [MESSAGE: numberOfRooms : null : MANDATORY_FIELD_EMPTY]', 'Error while validating input for the resource. [MESSAGE: livingSpace : null : MANDATORY_FIELD_EMPTY]', 'Error while validating input for the resource. [MESSAGE: title :  : MANDATORY_FIELD_EMPTY]', 'Error while validating input for the resource. [MESSAGE: courtageInformation.courtage :  : COURTAGE_EMPTY]']
        end
      end
    end

    context 'when message is not present' do
      it 'returns exception' do
        expect { described_class.new(nil) }.to raise_exception(ArgumentError)
      end
    end
  end
end
