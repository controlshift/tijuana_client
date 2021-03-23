# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

describe TijuanaClient do
  specify { expect(subject).to respond_to :user }
  specify { expect(subject.new).to be_a(TijuanaClient::Client) }
end
