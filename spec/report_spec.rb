require 'spec_helper'

RSpec.describe Immobilienscout::API::Report, type: :model do
  let!(:sandbox_url) { 'https://rest.sandbox-immobilienscout24.de' }
  let!(:configuration_double) { double(consumer_key: 'consumer_key', access_token: 'access_token', consumer_secret: 'consumer_secret', access_token_secret: 'access_token_secret') }

  before do
    Timecop.freeze(Time.new(2019, 6, 11, 12, 0, 0))
    allow(Immobilienscout::Client).to receive(:api_url).and_return(sandbox_url)
    allow(Immobilienscout).to receive(:configuration).and_return(configuration_double)
  end

  describe '#retrieve' do
    context 'when request is successful' do
      let!(:is24_id) { '315270728' }

      it 'returns created' do
        VCR.use_cassette('scout_report_generated_successfuly') do
          response = described_class.retrieve(is24_id, Date.today, Date.today)

          expect(response.code).to eq '200'
          expect(response.messages).to eq({"dailyReports"=>{"objectNumber"=>"S3W0UP6C", "reportDailyData"=>{"date"=>"2019-06-11", "matchesResultList"=>"0",
            "displaysResultList"=>"0", "exposeHits"=>"0", "onShortList"=>"0", "clicksHomepage"=>"0", "emailContacts"=>"0", "clicksSendUrl"=>"0", "clickFocusPlacement"=>"0",
            "showMiniExposeFocusPlacement"=>"0", "displayFocusPlacement"=>"0"}}})
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when date_to is bigger than date_from' do
        let!(:is24_id) { '315270728' }

        it 'returns precondition failed' do
          VCR.use_cassette('date_from_is_bigger_than_date_in_scout_report') do
            expect { described_class.retrieve(is24_id, Date.today, Date.yesterday) }.to raise_exception(Immobilienscout::Errors::InvalidRequest, 'The parameter [dateFrom = 2019-06-11 dateTo = 2019-06-10] '\
              'has an invalid value [Negative date range].')
          end
        end
      end

      context 'when parameters are not present' do
        let!(:is24_id) { '315270728' }

        it 'returns exception' do
          expect { described_class.retrieve(nil, Date.today, Date.today) }.to raise_exception(ArgumentError)
          expect { described_class.retrieve(is24_id, nil, Date.today) }.to raise_exception(ArgumentError)
          expect { described_class.retrieve(is24_id, Date.today, nil) }.to raise_exception(ArgumentError)
        end
      end

      context 'when deal does not exist on immobilienscout' do
        let!(:is24_id) { 'thisIsNotAValidId' }

        it 'returns exception' do
          VCR.use_cassette('property_to_create_report_does_not_exist_on_is24') do
            expect { described_class.retrieve(is24_id, Date.today, Date.today) }.to raise_exception(Immobilienscout::Errors::InvalidRequest, 'Resource [realestate] with id '\
              '[thisIsNotAValidId] not found.')
          end
        end
      end
    end
  end
end
