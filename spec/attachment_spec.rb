# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Immobilienscout::API::Attachment, type: :class do
  let(:attachment) { File.open('spec/fixtures/files/image.png') }
  let!(:sandbox_url) { 'https://rest.sandbox-immobilienscout24.de' }
  let!(:configuration_double) { instance_double('Immobilienscout::Configuration', consumer_key: 'consumer_key', access_token: 'access_token', consumer_secret: 'consumer_secret', access_token_secret: 'access_token_secret') }

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
end
