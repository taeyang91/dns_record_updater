require 'net/http'

module DNSRecordUpdater
  class DNSUpdater
    def initialize(provider, notification_service: nil)
      @provider = provider
      @notification_service = notification_service
    end

    def update(send_notification: false)
      ip = fetch_public_ip
      puts "Detected public IP: #{ip}"

      dns_record = @provider.fetch_dns_record
      record_id = dns_record[:record_id]
      current_ip = dns_record[:current_ip]

      if ip == current_ip
        puts "IP has not changed: #{ip}"
        return true
      end

      success = @provider.update_dns_record(ip, record_id)
      if send_notification && success
        @notification_service&.notify("DNS record updated: #{@provider.record_name} -> #{ip}")
      end
      success
    rescue StandardError => e
      puts "Error during update: #{e.message}"
      false
    end

    private

    def fetch_public_ip
      ipv4_regex = /\A((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\z/
      sources = [
        "https://cloudflare.com/cdn-cgi/trace",
        "https://api.ipify.org",
        "https://ipv4.icanhazip.com"
      ]

      sources.each do |url|
        response = Net::HTTP.get(URI(url))
        ip = response[/\d+\.\d+\.\d+\.\d+/]
        return ip if ip&.match?(ipv4_regex)
      end

      raise "Unable to fetch a valid public IP address."
    end
  end
end
