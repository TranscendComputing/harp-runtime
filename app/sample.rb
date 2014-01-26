require "sinatra/config_file"
require 'securerandom'
require 'harp_runtime'

# SampleApp loads up some predefined samples of Harp scripts.
class SampleApp < ApiBase

  register Sinatra::ConfigFile

  config_file File.join(File.dirname(__FILE__), '../config/settings.yaml')

  ##~ sapi = source2swagger.namespace("sample")
  ##~ sapi.swaggerVersion = "1.2"
  ##~ sapi.apiVersion = "0.1.0"
  ##~ sapi.basePath = "http://localhost:9393"
  ##~ sapi.resourcePath = "/api/v1/sample"

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/sample/"
  ##~ a.description = "List available sample Harp scripts."

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "List available sample Harp scripts"
  ##~ op.nickname = "file_list"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  get '/' do
    results = []
    Dir.glob(File.join(File.dirname(__FILE__), '../sample/*.harp')) do |harp_file|
      results.push(/.*\/(.*)/.match(harp_file)[1])
    end
    erb :file_list,  :layout => :layout_api, :locals => {:results => results}
  end

end
