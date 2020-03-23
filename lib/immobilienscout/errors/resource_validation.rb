# frozen_string_literal: true

module Immobilienscout
  module Errors
    class ResourceValidation < InvalidRequest
      def initialize(msg = message)
        super
      end
    end
  end
end
