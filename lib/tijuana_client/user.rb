module TijuanaClient
  class User < Base
    def base_path
      'users'
    end

    def create(params)
      post_json_request(normalized_base_path, params)
    end
  end
end