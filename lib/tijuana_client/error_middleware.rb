module TijuanaClient
  class ValidationError < ::Faraday::Error::ClientError ; end
  class EmailValidationError < ::Faraday::Error::ClientError ; end

  class ErrorMiddleware < ::Faraday::Response::RaiseError
    def on_complete(env)
      case env[:status]
        when 400
          if env.body.present?
            response = JSON.parse(env.body)
            if response['email'] && response['email'].include?('is invalid')
              raise TijuanaClient::EmailValidationError, response_values(env).to_s
            else
              raise TijuanaClient::ValidationError, response_values(env).to_s
            end
          else
           raise TijuanaClient::ValidationError, response_values(env).to_s
          end
        when ClientErrorStatuses
          raise Faraday::Error::ClientError, response_values(env).to_s
      end
    end
  end
end