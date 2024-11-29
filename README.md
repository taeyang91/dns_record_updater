# dns_record_updater [![Gem Version][]][gem-version]

Library for updating IPv4 DNS records on Cloudflare with support for notifications.

[Gem Version]: https://badge.fury.io/rb/dns_record_updater.svg
[gem-version]: https://rubygems.org/gems/dns_record_updater

## Installation

```
gem install dns_record_updater
```

## Usage

Here's a simple example of how to use the `DNSRecordUpdater` gem:

```ruby
notification_service = DNSRecordUpdater::NotificationService.new([
  slackuri=''          # URI for Slack WebHook "https://hooks.slack.com/services/xxxxx"
  discorduri=''        # URI for Discord WebHook "https://discordapp.com/api/webhooks/xxxxx"
])
cloudflare_provider = DNSRecordUpdater::CloudflareProvider.new({
  auth_email: '',      # The email used to login 'https://dash.cloudflare.com'
  auth_method: '',     # Set to "global" for Global API Key or "token" for Scoped API Token
  auth_key: '',        # Your API Token or Global API Key
  zone_identifier: '', # Can be found in the "Overview" tab of your domain
  record_name: ''      # record you want to be synced
}, notification_service)
dns_updater = DNSRecordUpdater::DNSUpdater.new(cloudflare_provider)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dns_record_updater. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dns_record_updater/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DnsRecordUpdater project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dns_record_updater/blob/main/CODE_OF_CONDUCT.md).
