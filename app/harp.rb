require 'rubygems'
require 'sinatra/base'
require 'lib/harp_runtime'
require 'logging'

class HarpApiApp < Sinatra::Base
  ##~ sapi = source2swagger.namespace("harp")
  ##~ sapi.swaggerVersion = "1.1"
  ##~ sapi.apiVersion = "1.0"

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp"
  ##~ a.description = "Harp runtime invocation"
  configure :production, :development do
    enable :logging
  end

  configure :development do
    base_logger = Logging.logger(STDOUT)
  end

  before do
    headers "Content-Type" => "text/html; charset=utf-8"
  end

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "List lifecycle stages supported"
  ##~ op.nickname = "get_lifecycle"
  ##~ op.parameters.add :name => "page", :description => "The page number of the query. Defaults to 1 if not provided", :dataType => "integer", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "per_page", :description => "Result set page size", :dataType => "integer", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :reason => "Query successful", :code => 200
  ##~ op.errorResponses.add :reason => "API down", :code => 500
  get '/:lifecycle' do
    logger.info "Root handler"
    interpreter = Harp::HarpInterpreter.new
    if params.key?("lifecycle")
      puts "Got #{params[:lifecycle]}"
    end

    results = interpreter.play("sample/basic_webapp.harp", params[:lifecycle])
    erb :default, :locals => {:lifecycle => params[:lifecycle], :results => results}
  end

  get '/' do
    erb :welcome
  end

  get '/docs' do
    send_file(File.join('docs', 'index.html'), {:type=>"html"})
  end

  # Routes for Swagger UI to gather web resources
  get %r{([^.]+).json} do |file|
    puts "Matched regex for #{file}."
    send_file(File.join('docs', "#{file}.json"), {:type=>"json"})
  end
end
