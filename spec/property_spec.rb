require 'spec_helper'

RSpec.describe Immobilienscout::API::Property, type: :model do
  let!(:sandbox_url) { 'https://rest.sandbox-immobilienscout24.de' }
  let!(:configuration_double) { double(consumer_key: 'consumer_key', access_token: 'access_token', consumer_secret: 'consumer_secret', access_token_secret: 'access_token_secret') }

  before do
    allow(Immobilienscout::Client).to receive(:api_url).and_return(sandbox_url)
    allow(Immobilienscout).to receive(:configuration).and_return(configuration_double)
  end

  describe '#create' do
    let!(:create_params) { {'realestates.apartmentBuy':{'externalId':'extID123','title':'RestAPi appartmentBuy','creationDate':'2014-08-12T15:56:52.000+02:00','address':{'street':'Andreasstraße','houseNumber':'10','postcode':'10243','city':'Berlin','wgs84Coordinate':{'latitude':52.51245,'longitude':13.43134},},'apiSearchData':{'searchField1':'apiSearchField1','searchField2':'apiSearchField2','searchField3':'apiSearchField3'},'realEstateState':'INACTIVE','descriptionNote':'Objektbeschreibung(noch 2000 Zeichen) description-note \n after line break this text is in the next row','furnishingNote':'Ausstattung(noch 2000 Zeichen)','locationNote':'Lage(noch 2000 Zeichen)','otherNote':'Sonstiges(noch 2000 Zeichen)','showAddress':'true','apartmentType':'MAISONETTE','floor':2,'lift':'true','energyCertificate':{'energyCertificateAvailability':'AVAILABLE','energyCertificateCreationDate':'BEFORE_01_MAY_2014'},'cellar':'YES','handicappedAccessible':'YES','numberOfParkingSpaces':1,'condition':'WELL_KEPT','lastRefurbishment':2010,'interiorQuality':'SOPHISTICATED','constructionYear':1995,'freeFrom':'sofort','heatingTypeEnev2014':'FLOOR_HEATING','energySourcesEnev2014':{'energySourceEnev2014':['WOOD_CHIPS']},'buildingEnergyRatingType':'ENERGY_CONSUMPTION','thermalCharacteristic':123.85,'energyConsumptionContainsWarmWater':'YES','numberOfFloors':5,'usableFloorSpace':70,'numberOfBedRooms':1,'numberOfBathRooms':2,'guestToilet':'YES','parkingSpaceType':'UNDERGROUND_GARAGE','rented':'YES','rentalIncome':895,'listed':'YES','parkingSpacePrice':15000,'summerResidencePractical':'YES','price':{'value':175000,'currency':'EUR','marketingType':'PURCHASE','priceIntervalType':'ONE_TIME_CHARGE'},'livingSpace':75,'numberOfRooms':3,'energyPerformanceCertificate':'true','builtInKitchen':'true','balcony':'true','certificateOfEligibilityNeeded':'false','garden':'true','courtage':{'hasCourtage':'YES','courtage':'Provisionshöhe (brutto)','courtageNote':'Provisionshinweis (noch 500 Zeichen)'},'serviceCharge':575}} }

    context 'when request is successful' do
      it 'returns created' do
        VCR.use_cassette('property_successfuly_created_is24') do
          parsed_response = described_class.create(create_params)

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '201'
          expect(parsed_response.messages.count).to eq 1
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_CREATED'
          expect(parsed_response.messages.first.messages).to eq 'Resource [realestate] with id [314712920] has been created.'
          expect(parsed_response.messages.first.id).to eq '314712920'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when all params are present' do
        context 'the property already exists' do
          it 'returns exception invalid request' do
            VCR.use_cassette('property_to_create_already_exists_is24') do
              expect { described_class.create(create_params) }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
            end
          end
        end
      end

      context 'when params are not present' do
        context 'property has no client param' do
          it 'returns exception argument error' do
            expect { described_class.create({}) }.to raise_exception(ArgumentError)
          end
        end

        context 'post request is missing required params' do
          let!(:incomplete_create_params) { {'realestates.apartmentBuy':{'externalId':'extID1234'}} }

          it 'returns exception invalid request' do
            VCR.use_cassette('missing_mandatory_params_to_create_is24') do
              expect { described_class.create(incomplete_create_params) }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
            end
          end
        end
      end
    end
  end

  describe '#update' do
    let!(:update_id) { '315676289' }
    let!(:update_ext_id) { 'HH73I0QJ' }
    let!(:update_params) { {'realestates.apartmentBuy':{'@id':'315676289','externalId':'HH73I0QJ','title':'Updated Title','address':{'street':'Updated Street','houseNumber':'12','postcode':'26382','city':'Wilhelmshaven','wgs84Coordinate':{'latitude':53.5212436,'longitude':8.1049089},'geoHierarchy':{'continent':{'geoCodeId':1,'fullGeoCodeId':'1'},'country':{'geoCodeId':276,'fullGeoCodeId':'1276'},'region':{'geoCodeId':9,'fullGeoCodeId':'1276009'},'city':{'geoCodeId':44,'fullGeoCodeId':'1276009044'},'quarter':{'geoCodeId':6,'fullGeoCodeId':'1276009044006'},'neighbourhood':{'geoCodeId':3405000000170}}},'realEstateState':'ACTIVE','descriptionNote':'New Description','locationNote':'New Location','showAddress':'false','contact':{'@id':'96701088'},'apartmentType':'APARTMENT','floor':1,'lift':'false','energyCertificate':{'energyCertificateAvailability':'AVAILABLE','energyCertificateCreationDate':'FROM_01_MAY_2014','energyEfficiencyClass':'G'},'cellar':'YES','handicappedAccessible':'NOT_APPLICABLE','numberOfParkingSpaces':0,'condition':'WELL_KEPT','interiorQuality':'NORMAL','constructionYear':1902,'heatingType':'SELF_CONTAINED_CENTRAL_HEATING','heatingTypeEnev2014':'SELF_CONTAINED_CENTRAL_HEATING','firingTypes':[{'firingType':'GAS'}],'energySourcesEnev2014':{'energySourceEnev2014':'GAS'},'buildingEnergyRatingType':'ENERGY_REQUIRED','thermalCharacteristic':217.5,'energyConsumptionContainsWarmWater':'NOT_APPLICABLE','numberOfFloors':3,'numberOfBedRooms':2,'numberOfBathRooms':1,'guestToilet':'NOT_APPLICABLE','rented':'YES','rentalIncome':365,'listed':'NOT_APPLICABLE','parkingSpacePrice':0,'summerResidencePractical':'NOT_APPLICABLE','price':{'value':200000,'currency':'EUR','marketingType':'PURCHASE','priceIntervalType':'ONE_TIME_CHARGE'},'livingSpace':66.93,'numberOfRooms':4,'energyPerformanceCertificate':'true','builtInKitchen':'false','balcony':'false','garden':'false','courtage':{'hasCourtage':'YES','courtage':'4,75% vom Kaufpreis inkl. 19% MwSt.'},'serviceCharge':132}} }

    context 'when request is successful' do
      it 'returns updated' do
        VCR.use_cassette('property_successfuly_updated_is24', record: :once) do
          parsed_response = described_class.update(update_id, update_params)
          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages.count).to eq 1
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_UPDATED'
          expect(parsed_response.messages.first.messages).to eq "Resource [realestate] with id [#{update_id}] has been updated."
          expect(parsed_response.messages.first.id).to eq update_id
        end

        VCR.use_cassette('show_updated_is24', record: :once) do
          parsed_show_response = described_class.show(update_id)
          expect(parsed_show_response.is_a?(Struct)).to eq true
          expect(parsed_show_response.success?).to eq true
          expect(parsed_show_response.code).to eq '200'
          expect(parsed_show_response.messages['realestates.apartmentBuy']['realEstateState']).to eq('ACTIVE')
          expect(parsed_show_response.messages['realestates.apartmentBuy']['title']).to eq('Updated Title')
          expect(parsed_show_response.messages['realestates.apartmentBuy']['address']['street']).to eq('Updated Street')
          expect(parsed_show_response.messages['realestates.apartmentBuy']['descriptionNote']).to eq('New Description')
          expect(parsed_show_response.messages['realestates.apartmentBuy']['price']['value']).to eq(200000)
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when all params are present' do
        context 'the property does not exists' do
          it 'returns exception invalid request' do
            VCR.use_cassette('property_to_update_does_not_exists_is24', record: :once) do
              expect { described_class.update('WrongID', update_params) }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
            end
          end
        end
      end

      context 'when params are not present' do
        context 'property has no client param' do
          it 'returns exception argument error' do
            expect { described_class.update(update_id, {}) }.to raise_exception(ArgumentError)
          end
        end

        context 'post request is missing required params' do
          let!(:incomplete_update_params) { {'realestates.apartmentBuy':{'externalId':'extID1234'}} }

          it 'returns exception invalid request' do
            VCR.use_cassette('missing_mandatory_params_to_update_is24', record: :once) do
              expect { described_class.update(update_id, incomplete_update_params) }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
            end
          end
        end
      end
    end
  end

  describe '#publish' do
    context 'when request is successful' do
      let!(:valid_publish_params) do
        {
          'common.publishObject': {
            realEstate: {
              '@id': '314712920',

            },
            publishChannel: {
              '@id': '10000'
            }
          }
        }
      end

      it 'returns created' do
        VCR.use_cassette('property_successfuly_published_is24') do
          parsed_response = described_class.publish(valid_publish_params)

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '201'
          expect(parsed_response.messages.count).to eq 1
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_CREATED'
          expect(parsed_response.messages.first.messages).to eq 'Resource [publish] with id [314712920_10000] has been created.'
          expect(parsed_response.messages.first.id).to eq '314712920_10000'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when all params are present' do
        context 'when the property does not exist' do
          let!(:invalid_publish_params) do
            {
              'common.publishObject': {
                realEstate: {
                  '@id': '1234567',

                },
                publishChannel: {
                  '@id': '10000'
                }
              }
            }
          end

          it 'returns exception invalid request' do
            VCR.use_cassette('invalid_resource_to_publish_is24') do
              expect { described_class.publish(invalid_publish_params) }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
            end
          end
        end
      end

      context 'when no params are present' do
        it 'returns exception argument error' do
          expect { described_class.publish({}) }.to raise_exception(ArgumentError)
        end
      end
    end
  end

  describe '#destroy' do
    context 'when request is successful' do
      it 'returns resource deleted' do
        VCR.use_cassette('property_successfully_deleted') do
          parsed_response = described_class.destroy('315248789')

          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages.count).to eq 1
          expect(parsed_response.messages.first.code).to eq 'MESSAGE_RESOURCE_DELETED'
          expect(parsed_response.messages.first.messages).to eq 'Resource [realestate] with id [315248789] has been deleted.'
          expect(parsed_response.messages.first.id).to eq '315248789'
        end
      end
    end

    context 'when request is unsuccessful' do
      context 'when the property id is not valid' do
        it 'returns invalid request' do
          VCR.use_cassette('property_to_delete_does_not_exist_on_is24') do
            expect { described_class.destroy('thisIsNotAValidId') }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
          end
        end
      end
    end
  end

  describe '#show' do
    context 'when object exists and is active' do
      it 'returns the resource' do
        VCR.use_cassette('active_property_successfully_retrieved') do
          parsed_response = described_class.show('315661708')
          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages['realestates.apartmentBuy']['@id']).to eq('315661708')
          expect(parsed_response.messages['realestates.apartmentBuy']['externalId']).to eq('extID123')
          expect(parsed_response.messages['realestates.apartmentBuy']['realEstateState']).to eq('ACTIVE')
        end
      end
    end

    context 'when object exists and is in-active' do
      it 'returns the resource' do
        VCR.use_cassette('inactive_property_successfully_retrieved') do
          parsed_response = described_class.show('315661713')
          expect(parsed_response.is_a?(Struct)).to eq true
          expect(parsed_response.success?).to eq true
          expect(parsed_response.code).to eq '200'
          expect(parsed_response.messages['realestates.apartmentBuy']['@id']).to eq('315661713')
          expect(parsed_response.messages['realestates.apartmentBuy']['externalId']).to eq('extID123INACTIVE')
          expect(parsed_response.messages['realestates.apartmentBuy']['realEstateState']).to eq('INACTIVE')
        end
      end
    end

    context 'when object does not exist' do
      it 'returns the resource' do
        VCR.use_cassette('property_to_show_does_not_exist') do
          expect { described_class.show('000000000') }.to raise_exception(Immobilienscout::Errors::InvalidRequest) { |exception|
            expect(exception.message).to eq('["Resource was not found."]')
          }
        end
      end
    end
  end
end
