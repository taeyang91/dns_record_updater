# frozen_string_literal: true

module DNSRecordUpdater
  class CloudflareProvider < DNSProvider
    def initialize(config)
      @auth_email = config[:auth_email]
      @auth_method = config[:auth_method]
      @auth_key = config[:auth_key]
      @zone_identifier = config[:zone_identifier]
      @record_name = config[:record_name]
      @ttl = config[:ttl] || 3600
      @proxy = config[:proxy] || false
    end

    def fetch_dns_record
      auth_header = @auth_method == "global" ? "X-Auth-Key" : "Authorization: Bearer"
      uri = URI("https://api.cloudflare.com/client/v4/zones/#{@zone_identifier}/dns_records?type=A&name=#{@record_name}")
      request = Net::HTTP::Get.new(uri)
      request["X-Auth-Email"] = @auth_email
      request[auth_header] = @auth_key

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
      result = JSON.parse(response.body)

      if result["success"]
        record = result["result"].first
        { record_id: record["id"], current_ip: record["content"] }
      else
        raise "Failed to fetch DNS record: #{result['errors']}"
      end
    end

    def update_dns_record(ip, record_id)
      auth_header = @auth_method == "global" ? "X-Auth-Key" : "Authorization: Bearer"
      uri = URI("https://api.cloudflare.com/client/v4/zones/#{@zone_identifier}/dns_records/#{record_id}")
      request = Net::HTTP::Patch.new(uri)
      request["X-Auth-Email"] = @auth_email
      request[auth_header] = @auth_key
      request["Content-Type"] = "application/json"
      request.body = { type: "A", name: @record_name, content: ip, ttl: @ttl, proxied: @proxy }.to_json

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
      result = JSON.parse(response.body)

      if result["success"]
        puts "Updated DNS record: #{@record_name} -> #{ip}"
        true
      else
        puts "Failed to update DNS record: #{result['errors']}"
        false
      end
    end
  end
end
