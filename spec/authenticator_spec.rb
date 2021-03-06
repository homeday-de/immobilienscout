# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Immobilienscout::Authenticator, type: :model do
  describe '#call' do
    context 'when params are present' do
      context 'when query params are not present' do
        let!(:configuration_double) { instance_double('Immobilienscout::Configuration', consumer_key: 'consumer_key', access_token: 'access_token', consumer_secret: 'consumer_secret', access_token_secret: 'access_token_secret') }
        let!(:service) { described_class.new('https://rest.sandbox-immobilienscout24.de/restapi/api/offer/v1.0/user/me/realestate', 'POST') }

        it 'returns authorization string' do
          allow(Immobilienscout).to receive(:configuration).and_return(configuration_double)
          allow(service).to receive('random_bytes').and_return('=\x9D\xE9\xD2\x1E\xF1\xD5')

          Timecop.freeze('2019-01-21 12:00:00 +0200') do
            response = service.call

            expect(response).to eq('OAuth oauth_consumer_key=consumer_key,oauth_nonce=PVx4OURceEU5XHhEMlx4MUVceEYxXHhENQ,oauth_signature_method=HMAC-SHA1,'\
              'oauth_timestamp=1548064800,oauth_token=access_token,oauth_version=1.0,oauth_signature=x3HEE425zb0WaD6It%2FjGZSdCRhE%3D')
          end
        end
      end
    end

    context 'when params are not present' do
      context 'when url is not present' do
        let(:service) { described_class.new(nil, 'POST') }

        it 'raises exception' do
          expect { service.call }.to raise_exception(ArgumentError)
        end
      end

      context 'when method is not present' do
        let(:service) { described_class.new('https://rest.sandbox-immobilienscout24.de/restapi/api/offer/v1.0/user/me/realestate', nil) }

        it 'raises exception' do
          expect { service.call }.to raise_exception(ArgumentError)
        end
      end

      context 'when method is not included' do
        let(:service) { described_class.new('https://rest.sandbox-immobilienscout24.de/restapi/api/offer/v1.0/user/me/realestate', 'POSTO') }

        it 'raises exception' do
          expect { service.call }.to raise_exception(ArgumentError)
        end
      end
    end
  end
end
