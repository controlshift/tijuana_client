require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TijuanaClient::Client do
  specify { expect(subject).to respond_to :user }

  describe "instantiated" do
    subject { described_class.new(options) }

    context 'process_basic_auth' do
      let(:options) { { :basic_auth => 'login:password' } }
      let(:config) { subject.connection.configuration  }
      specify { expect(config.username).to eq 'login' }
      specify { expect(config.password).to eq 'password' }
    end

  end
end
