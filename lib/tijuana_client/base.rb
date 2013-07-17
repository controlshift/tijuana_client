module TijuanaClient
  class Base < Vertebrae::API
    def normalized_base_path
      "/api/#{base_path}/"
    end

    def post_json_request(path, params)
      p = {}
      p['data'] = params.to_json
      post_request(path, p)
    end

    def request(method, path, params, options) # :nodoc:
      if !::Vertebrae::Request::METHODS.include?(method)
        raise ArgumentError, "unknown http method: #{method}"
      end

      conn = connection(options.merge(current_options))
      path =  conn.path_prefix + '/' + path

      ::Vertebrae::Base.logger.debug "EXECUTED: #{method} - #{path} with #{params} and #{options}"

      conn.send(method) do |request|

        case method.to_sym
          when *(::Vertebrae::Request::METHODS - ::Vertebrae::Request::METHODS_WITH_BODIES)
            request.body = params.delete('data') if params.has_key?('data')
            request.url(path, params)
          when *::Vertebrae::Request::METHODS_WITH_BODIES
            request.path = path
            request.body = extract_data_from_params(params) unless params.empty?
        end
      end
    end

    def default_middleware(options={})
      Proc.new do |builder|
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Vertebrae::Request::BasicAuth, authentication if authenticated?

        builder.use Faraday::Response::Logger if ENV['DEBUG']

        builder.use Vertebrae::Response::RaiseError
        builder.adapter adapter
      end
    end

    private

    def extract_data_from_params(params)
      if params.has_key?('data') && params['data'].present?
        return "data=#{params['data']}"
      else
        return params
      end
    end

  end
end