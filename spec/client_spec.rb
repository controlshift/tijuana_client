require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TijuanaClient::Client do
  specify { subject.should respond_to :user }

  describe "instantiated" do
    subject { described_class.new(options) }

    context 'process_basic_auth' do
      let(:options) { { :basic_auth => 'login:password' } }
      let(:config) { subject.connection.configuration  }
      specify { config.username.should eq 'login' }
      specify { config.password.should eq 'password' }
    end

  end
end
