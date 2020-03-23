# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Immobilienscout::RequestErrorHandler, type: :model do
  Message = Struct.new(:success?, :code, :messages)
  ERROR_RESOURCE_NOT_FOUND = 'ERROR_RESOURCE_NOT_FOUND'
  ERROR_COMMON_RESOURCE_NOT_FOUND = 'ERROR_COMMON_RESOURCE_NOT_FOUND'
  ERROR_RESOURCE_VALIDATION = 'ERROR_RESOURCE_VALIDATION'

  describe 'ERROR_RESOURCE_NOT_FOUND' do
    it 'raises an ResourceNotFound error if messages is an Array' do
      parsed_response = Message.new(false, 412, [Message.new(nil, ERROR_RESOURCE_NOT_FOUND, 'Resource was not found.')])
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::ResourceNotFound)
    end

    it 'raises an ResourceNotFound error if messages is a Hash' do
      parsed_response = Message.new(false, 412, 'messageCode' => ERROR_RESOURCE_NOT_FOUND, 'message' => 'Resource was not found.')
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::ResourceNotFound)
    end
  end

  describe 'ERROR_COMMON_RESOURCE_NOT_FOUND' do
    it 'raises an ResourceNotFound error if messages is an Array' do
      parsed_response = Message.new(false, 412, [Message.new(nil, ERROR_COMMON_RESOURCE_NOT_FOUND, 'Resource was not found.')])
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::CommonResourceNotFound)
    end

    it 'raises an ResourceNotFound error if messages is a Hash' do
      parsed_response = Message.new(false, 412, 'messageCode' => ERROR_COMMON_RESOURCE_NOT_FOUND, 'message' => 'Resource was not found.')
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::CommonResourceNotFound)
    end
  end

  describe 'ERROR_RESOURCE_VALIDATION' do
    it 'raises an ResourceNotFound error if messages is an Array' do
      parsed_response = Message.new(false, 412, [Message.new(nil, ERROR_RESOURCE_VALIDATION, 'Error
        while validating input for the resource. [MESSAGE: the name of the attachment
        file must be specified.]')])
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::ResourceValidation)
    end

    it 'raises an ResourceNotFound error if messages is a Hash' do
      parsed_response = Message.new(false, 412, 'messageCode' => ERROR_RESOURCE_VALIDATION, 'message' => 'Error
        while validating input for the resource. [MESSAGE: the name of the attachment
        file must be specified.]')
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::ResourceValidation)
    end
  end

  describe 'default error' do
    it 'raises an InvalidRequest error if messages is an Array' do
      parsed_response = Message.new(false, 412, [Message.new(nil, 'SOME_CODE', 'Some message')])
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
    end

    it 'raises an InvalidRequest error if messages is a Hash' do
      parsed_response = Message.new(false, 412, 'messageCode' => 'SOME_CODE', 'message' => 'Some message')
      expect { described_class.handle(parsed_response) }.to raise_exception(Immobilienscout::Errors::InvalidRequest)
    end
  end
end
