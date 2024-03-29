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
  let(:default_placement_type) { :premium_placement }

  before do
    allow(Immobilienscout::Client).to receive(:api_url).and_return(sandbox_url)
    allow(Immobilienscout).to receive(:configuration).and_return(configuration_double)
  end

  describe '#add' do
    context 'when request is successful' do
      it 'returns created for the respective placement type' do
        %w[top premium showcase].each do |placement_type|
          VCR.use_cassette("on_top_placement_#{placement_type}_creation_successful_is24") do
            parsed_response = described_class.add(ext_id, [placement_type, 'placement'].join('_').to_sym)

            expect(parsed_response.is_a?(Struct)).to eq true
            expect(parsed_response.success?).to eq true
            expect(parsed_response.code).to eq '200'
            expect(parsed_response.messages.count).to eq 1
            expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_CREATED'
            expect(parsed_response.messages.first.messages).to eq "Resource [#{[placement_type, 'placement'].join}] with id [] has been created."
          end
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when all params are present' do
        context 'when the on-top placement could not be created' do
          it 'returns exception invalid request' do
            VCR.use_cassette('on_top_placement_creation_failed_is24') do
              expect { described_class.add(ext_id, default_placement_type) }.to raise_exception(Immobilienscout::Errors::ResourceValidation)
            end
          end
        end
      end

      context 'when params are not present or invalid' do
        context 'when is24_id is blank' do
          it 'returns exception argument error' do
            expect { described_class.add(nil, default_placement_type) }.to raise_exception(ArgumentError)
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

  describe '#show' do
    context 'when request is successful' do
      it 'returns the respective on-top placement' do
        %w[top premium showcase].each do |placement_type|
          VCR.use_cassette("on_top_placement_show_#{placement_type}_is24") do
            parsed_response = described_class.show(ext_id, [placement_type, 'placement'].join('_').to_sym)

            expect(parsed_response.is_a?(Struct)).to eq true
            expect(parsed_response.success?).to eq true
            expect(parsed_response.code).to eq '200'
            expect(parsed_response.messages.count).to eq 1
            expect(parsed_response.messages.first.code).to eq 'MESSAGE_OPERATION_SUCCESSFUL'
            expect(parsed_response.messages.first.message).to eq 'activated'
            expect(parsed_response.messages.first.placement_type).to eq [placement_type, 'placement'].join('_').to_sym
            expect(parsed_response.messages.first.service_period_from).to eq DateTime.parse('2023-06-02T16:49:37.000+02:00')
            expect(parsed_response.messages.first.service_period_to).to eq DateTime.parse('2023-07-02T23:59:59.000+02:00')
            expect(parsed_response.messages.first.id).to eq '123456789'
            expect(parsed_response.messages.first.external_id).to eq 'ABC123'
          end
        end
      end
    end

    context 'when request is unsuccessful' do
      it 'returns the error message' do
        VCR.use_cassette('on_top_placement_show_failed_is24') do
          parsed_response = described_class.show(ext_id, default_placement_type)

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages.first.code).to eq 'ERROR_REQUESTED_DATA_NOT_FOUND'
          expect(parsed_response.messages.first.message).to eq 'not activated'
          expect(parsed_response.messages.first.id).to eq '123456789'
          expect(parsed_response.messages.first.external_id).to eq 'ABC123'
        end
      end
    end
  end

  describe '#destroy' do
    context 'when request is successful' do
      it 'returns deleted' do
        VCR.use_cassette('on_top_placement_deletion_successful_is24') do
          parsed_response = described_class.destroy(ext_id, default_placement_type)

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_DELETED'
          expect(parsed_response.messages.first.messages).to eq 'Resource [premiumplacement] with id [] has been deleted.'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when all params are present' do
        context 'when the on-top placement could not be deleted' do
          it 'returns exception invalid request' do
            VCR.use_cassette('on_top_placement_deletion_failed_is24') do
              expect { described_class.destroy(ext_id, default_placement_type) }.to raise_exception(Immobilienscout::Errors::ResourceValidation)
            end
          end
        end
      end

      context 'when params are not present or invalid' do
        context 'when is24_id is blank' do
          it 'returns exception argument error' do
            expect { described_class.destroy(nil, default_placement_type) }.to raise_exception(ArgumentError)
          end
        end

        context 'when placement_type is blank' do
          it 'returns exception argument error' do
            expect { described_class.destroy(ext_id, nil) }.to raise_exception(ArgumentError)
          end
        end

        context 'when placement_type is invalid' do
          it 'returns exception argument error' do
            expect { described_class.destroy(ext_id, :foobar) }.to raise_exception(ArgumentError)
          end
        end
      end
    end
  end
end
