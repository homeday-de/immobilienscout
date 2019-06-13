module Immobilienscout
  module Errors
    class InvalidRequest < StandardError
      def initialize(msg = message)
        super
      end
    end
  end
end
