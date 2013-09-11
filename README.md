# Harp

Spin up infrastructure and services in a cloud, virtualized, or baremetal
environment.

## Installation

This application is both a gem and a Sinatra application.

### Starting Up

For local testing, you can invoke the app with Shotgun.

    bundle install
    shotgun config.ru

Browse to the local server at http://localhost:9393.

### Generate documentation, invoke API

The API documentation is generated form source, and includes the ability to 
invoke the API from the documentation.  Type the following to generate documentation:

    # If you haven't already, bundle
    bundle install
    ./script/document

After generating the documentation, the live API documents are available.

    http://localhost:9393/docs/api.html
    
Ruby RDoc is available as well:

    http://localhost:9393/docs/index.html

### To use as a Gem

Add this line to your application's Gemfile:

    gem 'harp-runtime'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install harp-runtime

## Usage

Some sample harp scripts are included in the /sample directory.  Check out the
samples for intended usage.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
