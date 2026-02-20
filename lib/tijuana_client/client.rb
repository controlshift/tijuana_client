# frozen_string_literal: true

module TijuanaClient
  class Client < Vertebrae::API
    def user
      @user ||= TijuanaClient::User.new(client: self)
    end

    def post_json_request(path, params)
      p = {}
      p['data'] = params.to_json
      post_request(path, p)
    end

    def default_options
      {
        user_agent: 'TijuanaClient',
        prefix: '',
        content_type: 'application/x-www-form-urlencoded'
      }
    end

    def request(method, path, params, options) # :nodoc:
      raise ArgumentError, "unknown http method: #{method}" unless ::Vertebrae::Request::METHODS.include?(method)

      path = "#{connection.configuration.prefix}/#{path}"

      ::Vertebrae::Base.logger.debug "EXECUTED: #{method} - #{path} with #{params} and #{options}"

      connection.connection.send(method) do |request|
        case method.to_sym
        when *(::Vertebrae::Request::METHODS - ::Vertebrae::Request::METHODS_WITH_BODIES)
          request.body = params.delete('data') if params.key?('data')
          request.url(path, params)
        when *::Vertebrae::Request::METHODS_WITH_BODIES
          request.path = path
          request.body = extract_data_from_params(params) unless params.empty?
        end
      end
    end

    def setup
      connection.faraday_connection = Faraday.new(connection.configuration.faraday_options) do |f|
        f.request :multipart
        f.request :url_encoded
        if connection.configuration.authenticated?
          f.request :authorization, :basic, connection.configuration.username, connection.configuration.password
        end

        f.response :logger if ENV['DEBUG']

        f.use TijuanaClient::ErrorMiddleware
        f.adapter connection.configuration.adapter
      end
    end

    private

    def extract_data_from_params(params)
      if params.key?('data') && params['data'].present?
        { 'data' => params['data'] }
      else
        params
      end
    end
  end
end
