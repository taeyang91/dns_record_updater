# frozen_string_literal: true

RSpec.describe DNSRecordUpdater::CloudflareProvider do
  let(:config) do
    {
      auth_email: 'test@example.com',
      auth_method: 'global',
      auth_key: 'test_key',
      zone_identifier: 'zone_id',
      record_name: 'example.com',
      ttl: 3600,
      proxy: false
    }
  end

  let(:provider) { described_class.new(config) }

  describe '#initialize' do
    it 'initializes with the correct configuration' do
      expect(provider.instance_variable_get(:@auth_email)).to eq('test@example.com')
      expect(provider.instance_variable_get(:@auth_method)).to eq('global')
      expect(provider.instance_variable_get(:@auth_key)).to eq('test_key')
      expect(provider.instance_variable_get(:@zone_identifier)).to eq('zone_id')
      expect(provider.instance_variable_get(:@record_name)).to eq('example.com')
      expect(provider.instance_variable_get(:@ttl)).to eq(3600)
      expect(provider.instance_variable_get(:@proxy)).to eq(false)
    end
  end

  describe '#fetch_dns_record' do
    context 'when the request is successful' do
      it 'returns the DNS record' do
        response_body = {
          "success" => true,
          "result" => [
            { "id" => "record_id", "content" => "1.2.3.4" }
          ]
        }.to_json
        stub_request(:get, "https://api.cloudflare.com/client/v4/zones/zone_id/dns_records?type=A&name=example.com")
          .to_return(status: 200, body: response_body, headers: {})

        expect(provider.fetch_dns_record).to eq({ record_id: 'record_id', current_ip: '1.2.3.4' })
      end
    end

    context 'when the request fails' do
      it 'raises an error' do
        response_body = {
          "success" => false,
          "errors" => ["Some error"]
        }.to_json
        stub_request(:get, "https://api.cloudflare.com/client/v4/zones/zone_id/dns_records?type=A&name=example.com")
          .to_return(status: 400, body: response_body, headers: {})

        expect { provider.fetch_dns_record }.to raise_error(RuntimeError, "Failed to fetch DNS record: [\"Some error\"]")
      end
    end
  end

  describe '#update_dns_record' do
    context 'when the update is successful' do
      it 'returns true' do
        response_body = { "success" => true }.to_json
        stub_request(:patch, "https://api.cloudflare.com/client/v4/zones/zone_id/dns_records/record_id")
          .to_return(status: 200, body: response_body, headers: {})

        expect(provider.update_dns_record('5.6.7.8', 'record_id')).to be true
      end
    end

    context 'when the update fails' do
      it 'returns false' do
        response_body = { "success" => false, "errors" => ["Some error"] }.to_json
        stub_request(:patch, "https://api.cloudflare.com/client/v4/zones/zone_id/dns_records/record_id")
          .to_return(status: 400, body: response_body, headers: {})

        expect(provider.update_dns_record('5.6.7.8', 'record_id')).to be false
      end
    end
  end
end