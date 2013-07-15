$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'tijuana_client'
require 'webmock/rspec'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.color_enabled = true
end


RSpec.configure do |config|
  config.include WebMock::API


  config.before(:each) do
    WebMock.reset!
  end
  config.after(:each) do
    WebMock.reset!
  end

end

def stub_get(path)
  stub_tijuana_request(:get, path)
end

def stub_post(path)
  stub_tijuana_request(:post, path)
end

def stub_tijuana_request(method, path)
  prefix = TijuanaClient.prefix.to_s
  stub_request(method, "https://test.com" + prefix + path)
end

def reset_authentication_for(object)
  [ 'username', 'password' ].each do |item|
    TijuanaClient.send("#{item}=", nil)
    object.send("#{item}=", nil)
  end
end


def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(File.join(fixture_path, '/', file))
end
