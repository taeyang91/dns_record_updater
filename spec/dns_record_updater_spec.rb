# frozen_string_literal: true

RSpec.describe DNSRecordUpdater do
  it "has a version number" do
    expect(DNSRecordUpdater::VERSION).not_to be nil
  end
end