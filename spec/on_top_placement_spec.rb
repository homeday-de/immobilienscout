# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Immobilienscout::API::OnTopPlacement, type: :model do
  let(:sandbox_url) { 'https://rest.sandbox-immobilienscout24.de' }
  let(:configuration_double) do
    instance_double(
      'Immobilienscout::Configuration',
      consumer_key: 'consumer_key',
      access_token: 'access_token',
      consumer_secret: 'consumer_secret',
      access_token_secret: 'access_token_secret'
    )
  end
  let(:ext_id) { 'ext-ABC123' }
  let(:placement_type) { :premium_placement }

  before do
    allow(Immobilienscout::Client).to receive(:api_url).and_return(sandbox_url)
    allow(Immobilienscout).to receive(:configuration).and_return(configuration_double)
  end

  describe '#add' do
    context 'when request is successful' do
      it 'returns created' do
        VCR.use_cassette('on_top_placement_creation_successful_is24') do
          parsed_response = described_class.add(ext_id, placement_type)

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.id).to eq '123456789'
          expect(parsed_response.messages.count).to eq 1
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_OPERATION_SUCCESSFUL'
          expect(parsed_response.messages.first.message).to eq 'activated'
          expect(parsed_response.messages.first.service_period_from).to eq '2023-06-02T16:49:37.000+02:00'
          expect(parsed_response.messages.first.service_period_to).to eq '2023-07-02T23:59:59.000+02:00'
          expect(parsed_response.messages.first.external_id).to eq 'ABC123'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when all params are present' do
        context 'when the on-top placement could not be created' do
          it 'returns exception invalid request' do
            VCR.use_cassette('on_top_placement_creation_failed_is24') do
              expect { described_class.add(ext_id, placement_type) }.to raise_exception(Immobilienscout::Errors::ResourceValidation)
            end
          end
        end
      end

      context 'when params are not present or invalid' do
        context 'when is24_id is blank' do
          it 'returns exception argument error' do
            expect { described_class.add(nil, placement_type) }.to raise_exception(ArgumentError)
          end
        end

        context 'when placement_type is blank' do
          it 'returns exception argument error' do
            expect { described_class.add(ext_id, nil) }.to raise_exception(ArgumentError)
          end
        end

        context 'when placement_type is invalid' do
          it 'returns exception argument error' do
            expect { described_class.add(ext_id, :foobar) }.to raise_exception(ArgumentError)
          end
        end
      end
    end
  end

  describe '#delete' do
    context 'when request is successful' do
      it 'returns deleted' do
        VCR.use_cassette('on_top_placement_deletion_successful_is24') do
          parsed_response = described_class.delete(ext_id, placement_type)

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_DELETED'
          expect(parsed_response.messages.first.messages).to eq 'Resource [premiumplacement] with id [123456789] has been deleted.'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when all params are present' do
        context 'when the on-top placement could not be deleted' do
          it 'returns exception invalid request' do
            VCR.use_cassette('on_top_placement_deletion_failed_is24') do
              expect { described_class.delete(ext_id, placement_type) }.to raise_exception(Immobilienscout::Errors::ResourceValidation)
            end
          end
        end
      end

      context 'when params are not present or invalid' do
        context 'when is24_id is blank' do
          it 'returns exception argument error' do
            expect { described_class.delete(nil, placement_type) }.to raise_exception(ArgumentError)
          end
        end

        context 'when placement_type is blank' do
          it 'returns exception argument error' do
            expect { described_class.delete(ext_id, nil) }.to raise_exception(ArgumentError)
          end
        end

        context 'when placement_type is invalid' do
          it 'returns exception argument error' do
            expect { described_class.delete(ext_id, :foobar) }.to raise_exception(ArgumentError)
          end
        end
      end
    end
  end
end
