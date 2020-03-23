# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext'
require 'immobilienscout/authenticator'
require 'immobilienscout/request'
require 'immobilienscout/request_error_handler'
require 'immobilienscout/response_parser'
require 'immobilienscout/client'
require 'immobilienscout/api/property'
require 'immobilienscout/api/attachment'
require 'immobilienscout/api/report'
require 'immobilienscout/errors/invalid_request'
require 'immobilienscout/errors/common_resource_not_found'
require 'immobilienscout/errors/resource_not_found'
require 'immobilienscout/errors/resource_validation'

module Immobilienscout
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :consumer_key, :consumer_secret, :access_token, :access_token_secret, :use_sandbox
  end
end
