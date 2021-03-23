# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

describe TijuanaClient::User do
  subject { TijuanaClient.new(host: 'test.com') }

  describe 'configuration' do
    it 'should propagate the host' do
      expect(subject.user.client.connection.configuration.host).to eq('test.com')
    end
  end

  describe '.post_json_request' do
    let(:client) { TijuanaClient::Client.new }
    subject { TijuanaClient::User.new({ client: client }) }
    let(:path) { '/foo' }
    let(:params) { { first_name: 'Nathan' } }

    it 'should jsonify params' do
      expect(client).to receive(:post_request).with('/foo', { 'data' => JSON.generate({ first_name: 'Nathan' }) })
      client.post_json_request(path, params)
    end
  end

  describe 'create' do
    let(:body) { '' }
    let(:request_body) { { 'data' => JSON.generate({ first_name: 'Nathan' }) } }
    let(:request_path) { '/api/users/' }

    before(:each) do
      stub_post(request_path).with(body: request_body).to_return(body: body, status: status,
                                                                 headers: { content_type: 'application/json; charset=utf-8' })
    end

    describe 'success' do
      let(:status) { 200 }

      it 'should create a user' do
        subject.user.create(first_name: 'Nathan')
      end
    end

    describe 'an error' do
      let(:status) { 500 }

      it 'should raise' do
        expect { subject.user.create(first_name: 'Nathan') }.to raise_exception(StandardError)
      end
    end

    describe 'generic validation error' do
      let(:status) { 400 }
      let(:body) { '{"foo":["is bar"]}' }

      it 'should return nil' do
        expect { subject.user.create(first_name: 'Nathan') }.to raise_exception(TijuanaClient::ValidationError)
      end
    end

    describe 'email validation error' do
      let(:status) { 400 }
      let(:body) { '{"email":["is invalid"]}' }

      it 'should return nil' do
        expect { subject.user.create(first_name: 'Nathan') }.to raise_exception(TijuanaClient::EmailValidationError)
      end
    end
  end

  describe 'basic authentication' do
    subject { TijuanaClient.new(host: 'test.com', username: 'username', password: 'password') }

    let(:body) { '' }
    let(:request_body) { { 'data' => JSON.generate({ first_name: 'Nathan' }) } }
    let(:request_path) { '/api/users/' }

    before(:each) do
      stub_request(:post, "https://test.com#{request_path}").with(basic_auth: %w[username password], body: request_body)
                                                            .to_return(body: body, status: status, headers: { content_type: 'application/json; charset=utf-8' })
    end

    describe 'success' do
      let(:status) { 200 }

      it 'should create a user' do
        subject.user.create(first_name: 'Nathan')
      end
    end

    describe 'unauthorized' do
      let(:status) { 401 }

      it 'should return nil' do
        expect { subject.user.create(first_name: 'Nathan') }.to raise_exception(StandardError)
      end
    end
  end
end
