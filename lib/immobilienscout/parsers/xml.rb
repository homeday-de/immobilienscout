module Immobilienscout
  module Parsers
    class Xml < ResponseParser
      def parse
        response_body = JSON.parse(Hash.from_xml(@response.body).to_json)

        Message.new(success?, code, messages(response_body), id(response_body))
      end
    end
  end
end
