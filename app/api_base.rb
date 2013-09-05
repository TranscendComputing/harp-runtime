require 'rubygems'
require 'sinatra/base'
require 'logging'

class ApiBase < Sinatra::Base
  configure :production, :development do
    enable :logging
  end

  configure :development do
    base_logger = Logging.logger(STDOUT)
  end

  before { content_type 'application/json', :charset => 'utf-8' }

end
