module TijuanaClient
  module Configuration
    def self.included(mod)
      Vertebrae::Base.configure do |config|
        config.user_agent = 'TijuanaClient'
        config.prefix = ''
      end
    end
  end
end