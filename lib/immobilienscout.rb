require 'active_support'
require 'active_support/core_ext'
require 'immobilienscout/authenticator'
require 'immobilienscout/request'
require 'immobilienscout/response_parser'
require 'immobilienscout/client'
require 'immobilienscout/api/property'
require 'immobilienscout/api/attachment'
require 'immobilienscout/api/report'
require 'immobilienscout/errors/invalid_request'
require 'immobilienscout/parsers/json'
require 'immobilienscout/parsers/xml'

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
