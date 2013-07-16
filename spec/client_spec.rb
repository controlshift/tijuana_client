require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TijuanaClient::Client do
  specify { subject.should respond_to :user }

  describe "instantiated" do
    subject { described_class.new(options) }

    context 'process_basic_auth' do
      let(:options) { { :basic_auth => 'login:password' } }
      its(:username) { should eq 'login' }
      its(:password) { should eq 'password' }
      its(:basic_auth) { should eq 'login:password' }
    end

    context "process username & password" do
      let(:options) { { :username => 'login', password: 'password' } }
      its(:username) { should eq 'login' }
      its(:password) { should eq 'password' }
      its(:basic_auth) { should eq 'login:password' }
    end
  end
end
