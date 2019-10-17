require 'net/http/post/multipart'
require 'uri'

module Immobilienscout
  class Request
    def initialize(url, params = nil)
      @url = url
      @params = params

      raise ArgumentError unless valid?
    end

    def get
      auth_header = generate_auth_header('GET', @params)
      headers = generate_headers(auth_header)

      url_with_query = "#{@url}?#{@params.to_query}"
      uri = URI.parse(url_with_query)

      request = Net::HTTP::Get.new(uri)
      request.initialize_http_header(headers)

      execute_request(uri, request)
    end

    def post
      auth_header = generate_auth_header('POST')
      headers = generate_headers(auth_header)

      uri = URI.parse(@url)

      request = Net::HTTP::Post.new(uri)
      request.body = @params.to_json
      request.initialize_http_header(headers)

      execute_request(uri, request)
    end

    def post_with_multipart
      auth_header = generate_auth_header('POST')

      uri = URI.parse(@url)

      request = Net::HTTP::Post::Multipart.new(uri, @params)
      request.add_field('Authorization', auth_header)
      request.add_field('Accept', 'application/json')

      execute_request(uri, request)
    end

    def put
      auth_header = generate_auth_header('PUT')
      headers = generate_headers(auth_header)

      uri = URI.parse(@url)

      request = Net::HTTP::Put.new(uri)
      request.body = @params.to_json
      request.initialize_http_header(headers)

      execute_request(uri, request)
    end

    def delete
      auth_header = generate_auth_header('DELETE')
      headers = generate_headers(auth_header)

      uri = URI.parse(@url)

      request = Net::HTTP::Delete.new(uri)
      request.initialize_http_header(headers)

      execute_request(uri, request)
    end

    private

    def valid?
      @url.present?
    end

    def generate_auth_header(method_type, query_params = nil)
      Immobilienscout::Authenticator.new(@url, method_type, query_params).call
    end

    def generate_headers(auth_header)
      {
        'Authorization' => auth_header,
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    def execute_request(uri, request)
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |http| http.request request }
      Immobilienscout::ResponseParser.new(response).call
    end
  end
end
