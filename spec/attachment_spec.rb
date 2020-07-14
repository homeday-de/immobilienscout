# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Immobilienscout::API::Attachment, type: :class do
  let(:attachment) { File.open('spec/fixtures/files/image.png') }
  let!(:sandbox_url) { 'https://rest.sandbox-immobilienscout24.de' }
  let!(:configuration_double) do
    instance_double(
      'Immobilienscout::Configuration',
      consumer_key: 'consumer_key',
      access_token: 'access_token',
      consumer_secret: 'consumer_secret',
      access_token_secret: 'access_token_secret'
    )
  end

  before do
    allow(Immobilienscout::Client).to receive(:api_url).and_return(sandbox_url)
    allow(Immobilienscout).to receive(:configuration).and_return(configuration_double)
  end

  describe '#add' do
    context 'when request is successful' do
      it 'returns created' do
        VCR.use_cassette('attachment_is_successfuly_created_is24') do
          response = described_class.add('71624000', attachment, 'common.attachment': { '@xmlns': { 'common': 'http:\/\/rest.immobilienscout24.de\/schema\/common\/1.0' }, '@xsi.type': 'common:Picture', 'title': 'Kochecke', 'externalId': 'kitchen2' })

          expect(response.code).to eq '201'
          expect(response.messages.count).to eq 1
          expect(response.messages.first.code).to eq 'MESSAGE_RESOURCE_CREATED'
          expect(response.messages.first.messages).to eq 'Resource [attachment] with id [676069277] has been created.'
          expect(response.messages.first.id).to eq '676069277'
        end
      end
    end

    context 'when request is unsuccessful' do
      it 'when mandatory params for immobilienscout24 are not present' do
        VCR.use_cassette('missing_attachment_param_in_is24') do
          expect { described_class.add('71624000', nil, {}) }.to raise_exception(ArgumentError)
        end
      end

      it 'when mandatory params for add method are not present' do
        expect { described_class.add }.to raise_exception(ArgumentError)
      end
    end
  end

  describe '#put_order' do
    context 'when request is successful' do
      let(:params_with_ids) do
        {
          'attachmentsorder.attachmentsorder':
          {
            '@xmlns':
            {
              attachmentsorder: 'http://rest.immobilienscout24.de/schema/attachmentsorder/1.0'
            },
            attachmentId: %w[
              896939747
              896939746
              896939748
              896939750
              896939751
              896939749
              896939745
            ]
          }
        }
      end

      it 'returns success' do
        VCR.use_cassette('attachments_are_successfully_ordered_is24') do
          response = described_class.put_order('315523568', params_with_ids)

          expect(response.code).to eq '200'
          expect(response.messages.count).to eq 1
          expect(response.messages.first.code).to eq 'MESSAGE_RESOURCE_UPDATED'
          expect(response.messages.first.messages).to eq 'Resource [realestate] with id [315523568] has been updated.'
          expect(response.messages.first.id).to eq '315523568'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when mandatory params for immobilienscout24 are not present' do
        it 'returns Argument Error' do
          expect { described_class.put_order('315523568', {}) }.to raise_exception(ArgumentError)
        end
      end

      context 'when mandatory params for put_order method are not present' do
        it 'returns Argument Error' do
          expect { described_class.put_order }.to raise_exception(ArgumentError)
        end
      end
    end
  end

  describe '#retrieve_all' do
    context 'when a property exists and has attachments' do
      it 'returns the resource' do
        VCR.use_cassette('attachment_retrieve_all') do
          parsed_response = described_class.retrieve_all('ext-D1TGDF9V')
          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'

          expect(parsed_response['messages']['common.attachments'].first['attachment'][0]['@id']).to eq('897494197')
          expect(parsed_response['messages']['common.attachments'].first['attachment'][1]['@id']).to eq('897494198')
        end
      end
    end
  end

  describe '#destroy' do
    context 'when request is successful' do
      it 'returns resource deleted' do
        VCR.use_cassette('attachment_successfully_deleted') do
          parsed_response = described_class.destroy('ext-D1TGDF9V', '897494196')

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages.count).to eq 1
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_DELETED'
          expect(parsed_response.messages.first.messages).to eq 'Resource [attachment] with id [897494196] has been deleted.'
          expect(parsed_response.messages.first.id).to eq '897494196'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when the property id is not valid' do
        it 'returns invalid request' do
          VCR.use_cassette('attachment_to_delete_does_not_exist_on_is24') do
            expect { described_class.destroy('ext-D1TGDF9V', '00000') }.to raise_exception(Immobilienscout::Errors::ResourceNotFound)
          end
        end
      end
    end
  end
end
