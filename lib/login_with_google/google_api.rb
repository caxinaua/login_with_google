# frozen_string_literal: true

module LoginWithGoogle
  class Api
    class << self
      include ApiBase

      attr_accessor :show_url, :show_response

      def url_in
        [
          LoginWithGoogle.config['url']['login'], '?',
          CGI.unescape(login_params)
        ].join
      end

      def auth(options = {})
        data = LoginWithGoogle.config['auth'].clone
        data[:code] = options[:code]
        data[:redirect_uri] = redirect_uri
        http_post({
                    uri: URI(LoginWithGoogle.config['url']['auth']),
                    head: { 'content-type' => 'application/json' },
                    body: data.to_json
                  })
      end

      def refresh(options = {})
        data = LoginWithGoogle.config['refresh'].clone
        data[:refresh_token] = options[:token]
        http_post({
                    head: { 'content-type' => 'application/json' },
                    uri: URI(LoginWithGoogle.config['url']['refresh']),
                    body: data.to_json
                  })
      end

      def info(options = {})
        response = http_get({
                              uri: URI([
                                LoginWithGoogle.config['url']['info'],
                                "?access_token=#{options['access_token'] || options['token']}"
                              ].join)
                            })
        response
      end

      private

      def redirect_uri
        LoginWithGoogle.config['url']['callback']
      end

      def login_params
        params = LoginWithGoogle.config['url']['params_login'].clone
        params[:redirect_uri] = redirect_uri
        if params.respond_to?(:to_query)
          params.to_query
        else
          params.collect { |k, v| "#{k}=#{v}" }.join('&')
        end
      end
    end
  end
end
