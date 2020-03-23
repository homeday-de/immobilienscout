# frozen_string_literal: true

module Immobilienscout
  module Errors
    class CommonResourceNotFound < InvalidRequest
      def initialize(msg = message)
        super
      end
    end
  end
end
