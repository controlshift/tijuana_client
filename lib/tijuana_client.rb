require 'vertebrae'
require 'tijuana_client/error_middleware'
require 'tijuana_client/base'
require 'tijuana_client/user'
require 'tijuana_client/client'

module TijuanaClient
  extend Vertebrae::Base

  class << self
    def new(options = {}, &block)
      TijuanaClient::Client.new(options, &block)
    end
  end
end