require 'spec_helper'

RSpec.describe Immobilienscout::ResponseParser, type: :model do

  describe '#call' do
    context 'when message is present' do
      context 'when response is JSON' do
        context 'when response has just one message' do
          let!(:response) { double(code: '201', body: {'common.messages':[{'message':{'messageCode':'MESSAGE_RESOURCE_CREATED','message':'Resource [realestate] with id [314712920] has been created.','id':'314712920'}}]}.to_json) }
          let!(:service) { Immobilienscout::Parsers::Json.new(response) }

          it 'returns messages' do
            parsed_response = service.parse

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
          let!(:response) { double(code: '412', body: {'common.messages':[{'message':[{'messageCode':'ERROR_RESOURCE_VALIDATION','message':'Error while validating input for the resource. [MESSAGE: numberOfRooms : null : MANDATORY_FIELD_EMPTY]'},{'messageCode':'ERROR_RESOURCE_VALIDATION','message':'Error while validating input for the resource. [MESSAGE: livingSpace : null : MANDATORY_FIELD_EMPTY]'},{'messageCode':'ERROR_RESOURCE_VALIDATION','message':'Error while validating input for the resource. [MESSAGE: title :  : MANDATORY_FIELD_EMPTY]'},{'messageCode':'ERROR_RESOURCE_VALIDATION','message':'Error while validating input for the resource. [MESSAGE: courtageInformation.courtage :  : COURTAGE_EMPTY]'}]}]}.to_json) }
          let!(:service) { Immobilienscout::Parsers::Json.new(response) }

          it 'returns messages' do
            parsed_response = service.parse

            expect(parsed_response.is_a?(Struct)).to eq true
            expect(parsed_response.success?).to eq false
            expect(parsed_response.code).to eq '412'
            expect(parsed_response.messages.count).to eq 4
            expect(parsed_response.messages.map(&:messages)).to eq ['Error while validating input for the resource. [MESSAGE: numberOfRooms : null : MANDATORY_FIELD_EMPTY]', 'Error while validating input for the resource. [MESSAGE: livingSpace : null : MANDATORY_FIELD_EMPTY]', 'Error while validating input for the resource. [MESSAGE: title :  : MANDATORY_FIELD_EMPTY]', 'Error while validating input for the resource. [MESSAGE: courtageInformation.courtage :  : COURTAGE_EMPTY]']
          end
        end
      end

      context 'when response is XML' do
        context 'when response has just one message' do
          let!(:response) do
            double(
              code: '200',
              body: '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><dailyReports objectNumber="S3W0UP6C"><reportDailyData><date>2019-06-11</date><matchesResultList>0</matchesResultList><displaysResultList>0</displaysResultList><exposeHits>0</exposeHits><onShortList>0</onShortList><clicksHomepage>0</clicksHomepage><emailContacts>0</emailContacts><clicksSendUrl>0</clicksSendUrl><clickFocusPlacement>0</clickFocusPlacement><showMiniExposeFocusPlacement>0</showMiniExposeFocusPlacement><displayFocusPlacement>0</displayFocusPlacement></reportDailyData></dailyReports>'
            )
          end
          let!(:service) { Immobilienscout::Parsers::Xml.new(response) }

          it 'returns messages' do
            parsed_response = service.parse

            expect(parsed_response.is_a?(Struct)).to eq true
            expect(parsed_response.success?).to eq true
            expect(parsed_response.code).to eq '200'
            expect(parsed_response.messages.count).to eq 1
            expect(parsed_response.messages).to eq JSON.parse(Hash.from_xml(response.body).to_json)
          end
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
