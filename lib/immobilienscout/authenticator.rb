require 'open-uri'

module Immobilienscout
  class Authenticator
    ALLOWED_METHODS = %w(POST GET DELETE).freeze
    OAUTH_SIGNATURE_METHOD = 'HMAC-SHA1'.freeze
    OAUTH_VERSION = '1.0'.freeze
    HASH_DIGEST = 'sha1'.freeze

    def initialize(url, method, query_params = nil)
      @url = url
      @method = method
      @query_params = query_params

      raise ArgumentError unless valid?
    end

    def call
      header_params.merge!(@query_params) if @query_params
      auth_headers = auth_headers(header_params)

      auth_header_string(auth_headers)
    end

    private

    def valid?
      @url.present? && @method.present? && ALLOWED_METHODS.include?(@method)
    end

    def header_params
      @header_params ||= {
        oauth_consumer_key: Immobilienscout.configuration.consumer_key,
        oauth_nonce: generate_nonce,
        oauth_signature_method: OAUTH_SIGNATURE_METHOD,
        oauth_timestamp: generate_timestamp,
        oauth_token: Immobilienscout.configuration.access_token,
        oauth_version: OAUTH_VERSION
      }
    end

    def signing_key
      "#{url_encode(Immobilienscout.configuration.consumer_secret)}&#{url_encode(Immobilienscout.configuration.access_token_secret)}"
    end

    def generate_nonce
      Base64.encode64(random_bytes).gsub(/\W/, '')
    end

    def random_bytes(size=7)
      OpenSSL::Random.random_bytes(size)
    end

    def generate_timestamp
      Time.now.utc.to_i.to_s
    end

    def signature_base_string(params)
      "#{@method}&#{url_encode(@url)}&#{url_encode(params.to_query)}"
    end

    def generate_signature(signature_base_string)
      url_encode(sign(signing_key, signature_base_string))
    end

    def url_encode(string)
      CGI.escape(string)
    end

    def sign(key, base_string)
      digest = OpenSSL::Digest.new(HASH_DIGEST)
      hmac = OpenSSL::HMAC.digest(digest, key, base_string)
      Base64.encode64(hmac).chomp.delete(' ')
    end

    def auth_headers(header_params)
      signature_base_string = signature_base_string(header_params)
      header_params['oauth_signature'] = generate_signature(signature_base_string)
      header_params
    end

    def auth_header_string(params)
      header_params = params.each_with_object('OAuth ') do |(key, value), header|
        header << "#{key}=#{value},"
      end
      header_params.chop
    end
  end
end
