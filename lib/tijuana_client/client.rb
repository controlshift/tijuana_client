module TijuanaClient
  class Client < Vertebrae::API
    def user(options={}, &block)
      @user ||= TijuanaClient::User.new(current_options.merge(options), &block)
    end
  end
end