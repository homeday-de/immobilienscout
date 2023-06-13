# frozen_string_literal: true

module Immobilienscout
  class Client
    SANDBOX_URL = 'https://rest.sandbox-immobilienscout24.de'
    LIVE_URL = 'https://rest.immobilienscout24.de'

    def self.api_url
      return SANDBOX_URL if Immobilienscout.configuration.use_sandbox

      LIVE_URL
    end

    def self.me_url
      "#{api_url}/restapi/api/offer/v1.0/user/me"
    end
  end
end
