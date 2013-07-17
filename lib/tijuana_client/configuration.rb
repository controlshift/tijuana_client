module TijuanaClient
  module Configuration
    def self.included(mod)
      Vertebrae::Base.configure do |config|
        config.user_agent = 'TijuanaClient'
        config.prefix = ''
        config.content_type = 'application/x-www-form-urlencoded'
      end
    end
  end
end