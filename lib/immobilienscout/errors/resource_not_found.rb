# frozen_string_literal: true

module Immobilienscout
  module Errors
    class ResourceNotFound < InvalidRequest
      def initialize(msg = message)
        super
      end
    end
  end
end
