module Immobilienscout
  module Parsers
    class Json < ResponseParser
      def parse
        response_body = JSON.parse(@response.body)

        Message.new(success?, code, messages(response_body), id(response_body))
      end
    end
  end
end
