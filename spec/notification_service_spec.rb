# frozen_string_literal: true

RSpec.describe DNSRecordUpdater::NotificationService do
  let(:endpoints) { ['http://example.com/notify', 'http://another.com/notify'] }
  let(:service) { described_class.new(endpoints) }

  describe '#initialize' do
    it 'initializes with the correct endpoints' do
      expect(service.instance_variable_get(:@endpoints)).to eq(endpoints)
    end
  end

  describe '#notify' do
    let(:message) { 'Test message' }
    let(:payload) { { content: message }.to_json }

    before do
      endpoints.each do |endpoint|
        stub_request(:post, endpoint)
          .with(body: payload, headers: { "Content-Type" => "application/json" })
          .to_return(status: 200, body: '', headers: {})
      end
    end

    it 'sends a POST request to each endpoint with the correct payload' do
      service.notify(message)

      endpoints.each do |endpoint|
        expect(a_request(:post, endpoint)
          .with(body: payload, headers: { "Content-Type" => "application/json" }))
          .to have_been_made.once
      end
    end
  end
end