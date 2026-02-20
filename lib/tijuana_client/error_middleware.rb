# frozen_string_literal: true

module TijuanaClient
  class ValidationError < StandardError; end
  class EmailValidationError < StandardError; end

  class ErrorMiddleware < Faraday::Middleware
    def on_complete(env)
      case env[:status]
      when 400
        if env.body.present?
          response = JSON.parse(env.body)
          if response['email']&.include?('is invalid')
            raise TijuanaClient::EmailValidationError, response_values(env).to_s
          else
            raise TijuanaClient::ValidationError, response_values(env).to_s
          end
        else
          raise TijuanaClient::ValidationError, response_values(env).to_s
        end
      when 400..600
        raise Faraday::ClientError, response_values(env).to_s
      end
    end

    private

    def response_values(env)
      {
        status: env[:status],
        headers: env[:response_headers],
        body: env[:body]
      }
    end
  end
end
