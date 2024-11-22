module DNSRecordUpdater
  class DNSProvider
    attr_reader :record_name

    def fetch_dns_record
      raise NotImplementedError, "Must be implemented by a provider"
    end

    def update_dns_record(ip, record_id)
      raise NotImplementedError, "Must be implemented by a provider"
    end
  end
end
