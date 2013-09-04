require 'rubygems'
require 'sinatra/base'
require 'lib/harp_runtime'
require 'logging'

class RootApp < Sinatra::Base

  configure :production, :development do
    enable :logging
  end

  configure :development do
    base_logger = Logging.logger(STDOUT)
    #Logging.logger.root.level = :debug
  end

  before do
    headers "Content-Type" => "text/html; charset=utf-8"
  end

  get '/:lifecycle' do
    logger.info "Root handler"
    interpreter = HarpInterpreter.new
    if params.key?("lifecycle")
      puts "Got #{params[:lifecycle]}"
    end

    results = interpreter.play("sample/basic_webapp.harp", params[:lifecycle])
    erb :default, :locals => {:lifecycle => params[:lifecycle], :results => results}
  end

end
