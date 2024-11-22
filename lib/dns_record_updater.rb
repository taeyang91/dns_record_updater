# frozen_string_literal: true

require_relative "dns_record_updater/version"
require_relative "dns_record_updater/dns_updater"
require_relative "dns_record_updater/dns_provider"
require_relative "dns_record_updater/cloudflare_provider"
require_relative "dns_record_updater/notification_service"

module DNSRecordUpdater
  class Error < StandardError; end
  # Your code goes here...
end
