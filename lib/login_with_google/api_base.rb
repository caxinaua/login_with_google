# frozen_string_literal: true

require 'net/http'
module LoginWithGoogle
  module ApiBase
    def http_get(options)
      request = Net::HTTP::Get.new(options[:uri], options[:head])
      request.body = options[:body] if options[:body]
      JSON.parse(request_http(options, request).body)
    end

    def http_post(options)
      request = Net::HTTP::Post.new(options[:uri], options[:head])
      request.body = options[:body] if options[:body]
      request.basic_auth(*options[:auth]) if options[:auth]

      return request_http(options, request).body if options[:body_response]

      JSON.parse(request_http(options, request).body)
    end

    def http_delete(options)
      request = Net::HTTP::Delete.new(options[:uri], options[:head])
      request.body = options[:body] if options[:body]
      request_http(options, request)
    end

    private

    def request_http(options, request)
      http = Net::HTTP.new(options[:uri].hostname, options[:uri].port)
      http.use_ssl = options[:uri].scheme == 'https'
      http.request(request)
    end
  end
end
