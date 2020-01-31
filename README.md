# Sw::Logger

This Logger is used in SayWay's applications for context rich logging. That way we can easily extract metrics and analyze our JSON logs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sw-logger'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sw-logger

## Usage

```ruby
# get an instance of the logger that logs to standard output
logger = Sw.logger(STDOUT)

# it follows the normal logger interface
logger.info("Hello World")
# => I, [2020-01-31T11:00:08.577103 #29982]  INFO -- : Hello World

# it can be tagged
logger.tagged("MyApp") { |l| l.debug("is bug free!") }
# => D, [2020-01-31T11:00:35.585755 #29982] DEBUG -- : [MyApp] is bug free!

# you can provide context as a hash
context = {
  tenant: "FooCorp",
  revision: "4e0b166"
}
logger.with_context(context) { |l| l.info("Where am I?") }
# => I, [2020-01-31T11:00:58.063731 #29982]  INFO -- : [tenant=FooCorp] [revision=4e0b166] Where am I?

# nested context is just dumped as is for non-json formatters
logger.with_context(foo: { bar: 42 }) { |l| l.info("Use JSON instead!") }
# => I, [2020-01-31T11:01:57.894093 #29982]  INFO -- : [bar={:foo=>42}] Use JSON instead!

# you can go batshit crazy when using a json logger, anything that can be dumped to json is fair game
Sw.json_logger(STDOUT).with_context(foo: { bar: 42 }) { |l| l.info("Oooh, yeah!") }
# => {"bar":{"foo":42},"severity":"INFO","timestamp":"2020-01-31T11:27:34.848643","message":"Oooh, yeah!"}

# you can also chain tags and context,
# you also don't need to open a block for a single tagged / context enriched statement
logger.tagged("MyApp", "MyDomain").with_context(tenant: 42).info("Tags & Context apply only for this call.")
# => I, [2020-01-31T11:45:11.348817 #35215]  INFO -- : [MyApp] [MyDomain] [tenant=42] Tags & Context apply only for this call.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/say-way/sw-logger.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
