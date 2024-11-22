require 'net/http'

module DNSRecordUpdater
  class NotificationService
    def initialize(endpoints)
      @endpoints = endpoints
    end

    def notify(message)
      @endpoints.each do |uri|
        payload = { content: message }.to_json
        Net::HTTP.post(URI(uri), payload, { "Content-Type" => "application/json" })
      end
    end
  end
end
