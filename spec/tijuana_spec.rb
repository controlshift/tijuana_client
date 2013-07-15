require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TijuanaClient do
  specify { subject.should respond_to :user }
  specify { subject.new.should be_a(TijuanaClient::Client)}
end
