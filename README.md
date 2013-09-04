# Harp

Spin up infrastructure and services in a cloud, virtualized, or baremetal
environment.

## Installation

This application is both a gem and a Sinatra application.

### To run as app

For local testing, you can invoke the app with Shotgun.

    bundle install
    shotgun config.ru

Browse to the local server at http://localhost:9393.

Currently, a single script is invoked; different lifecycle events on the script
may be run by supplying different URLs.

Try:

    http://localhost:9393/create
    or
    http://localhost:9393/destroy

### To use as Gem

Add this line to your application's Gemfile:

    gem 'harp-engine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install harp-engine

## Usage

Some sample harp scripts are included in the /sample directory.  Check out the
samples for intended usage.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
