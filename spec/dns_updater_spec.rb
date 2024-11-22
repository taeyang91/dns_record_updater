# frozen_string_literal: true

RSpec.describe DNSRecordUpdater::DNSUpdater do
  let(:provider) { instance_double("DNSRecordUpdater::DNSProvider") }
  let(:notification_service) { instance_double("NotificationService") }
  let(:dns_updater) { described_class.new(provider, notification_service: notification_service) }

  describe '#update' do
    context 'when IP has not changed' do
      it 'returns true' do
        allow(provider).to receive(:fetch_dns_record).and_return({ record_id: '123', current_ip: '1.2.3.4' })
        allow(dns_updater).to receive(:fetch_public_ip).and_return('1.2.3.4')

        expect(dns_updater.update).to be true
      end
    end

    context 'when IP has changed' do
      it 'returns true and updates DNS record' do
        allow(provider).to receive(:fetch_dns_record).and_return({ record_id: '123', current_ip: '1.2.3.4' })
        allow(dns_updater).to receive(:fetch_public_ip).and_return('5.6.7.8')
        allow(provider).to receive(:update_dns_record).with('5.6.7.8', '123').and_return(true)

        expect(dns_updater.update).to be true
      end
    end
  end
end