require 'vertebrae'
require 'tijuana_client/configuration'
require 'tijuana_client/base'
require 'tijuana_client/user'
require 'tijuana_client/client'

module TijuanaClient
  extend Vertebrae::Base
  include TijuanaClient::Configuration

  class << self
    def new(options = {}, &block)
      TijuanaClient::Client.new(options, &block)
    end
  end
end