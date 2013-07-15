require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TijuanaClient::Client do
  specify { subject.should respond_to :user }
end
