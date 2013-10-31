require "sinatra/config_file"
require 'securerandom'

# The Harp API provides operations to deposit and invoke Harp scripts on the 
# Harp runtime.
class HarpApiApp < ApiBase

  register Sinatra::ConfigFile

  config_file File.join(File.dirname(__FILE__), '../config/settings.yaml')

  def prepare_context(params)
    auth = params[:auth] || nil
    if auth
      access = settings.send(params[:auth])[:access]
      secret = settings.send(params[:auth])[:secret]
      keys = settings.send(params[:auth])[:keys]
    else
      access = params[:access] || ""
      secret = params[:secret] || ""
      keys = nil
    end
    harp_location = params[:harp_location] || nil
    script = request.body.read

    context = { :access => access, :secret => secret, :keys => keys }
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true if params.key?("mock")
    if harp_location.nil?
      context[:harp_contents] = script
    else
      context[:harp_location] = harp_location
    end      
    if script != nil and script.length < 1000
      logger.debug("Got harp script: #{script}")
    end
    context[:break] = params[:break] || nil
    context[:step] = params[:step] if params[:step]
    context[:continue] = params[:continue] || nil
    context[:harp_id] = params[:harp_id] || nil
    context
  end

  def run_lifecycle(lifecycle, interpreter, context)
    begin
      results = interpreter.play(lifecycle, context)
      erb :harp_api_result,  :layout => :layout_api, :locals => {:lifecycle => lifecycle, :results => results}
    rescue => e
      logger.error("Error running script: #{e}")
      logger.error("Error running script: #{e.backtrace[1..-1].join("\n")}")
      erb :harp_api_error,  :layout => :layout_api, :locals => {:action => lifecycle, :error => "An error occurred."}
    end
  end

  def get_status(resource, interpreter, context)
    begin
      results = interpreter.status(resource, context)
      erb :harp_api_result,  :layout => :layout_api, :locals => {:lifecycle => lifecycle, :results => results}
    rescue => e
      logger.error("Error retrieving status: #{e}")
      logger.error("Error retrieving status: #{e.backtrace[1..-1].join("\n")}")
      erb :harp_api_error,  :layout => :layout_api, :locals => {:action => lifecycle, :error => "An error occurred."}
    end
  end

  def get_output(output_token, interpreter, context)
    begin
      results = interpreter.get_output(output_token, context)
      erb :harp_api_result,  :layout => :layout_api, :locals => {:results => results}
    rescue => e
      logger.error("Error running script: #{e}")
      logger.error("Error running script: #{e.backtrace[1..-1].join("\n")}")
      erb :harp_api_error,  :layout => :layout_api, :locals => {:action => "get_output", :error => "An error occurred."}
    end
  end

  ##~ sapi = source2swagger.namespace("harp")
  ##~ sapi.swaggerVersion = "1.2"
  ##~ sapi.apiVersion = "0.1.0"
  ##~ sapi.basePath = "http://localhost:9393"
  ##~ sapi.resourcePath = "/api/v1/harp"

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/create"
  ##~ a.description = "Harp runtime invocation of create"

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke normal create lifecycle"
  ##~ op.nickname = "run_create"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/create' do
    context = prepare_context(params)
    interpreter = Harp::HarpInterpreter.new(context)
    run_lifecycle(Harp::Lifecycle::CREATE, interpreter, context)
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/destroy/{harp_id}"
  ##~ a.description = "Harp runtime invocation of destroy"

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke normal destroy lifecycle"
  ##~ op.nickname = "run_destroy"
  ##~ op.parameters.add :name => "harp_id", :description => "Harp script execution ID", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/destroy/:harp_id' do
    context = prepare_context(params)
    interpreter = Harp::HarpInterpreter.new(context)
    run_lifecycle(Harp::Lifecycle::DESTROY, interpreter, context)
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/output/{harp_id}/{output_token}"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "Request the output for some step taken during execution of a harp script."
  ##~ op.nickname = "get_output"
  ##~ op.parameters.add :name => "harp_id", :description => "Harp script execution ID", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "output_token", :description => "Token from action which produced some output", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Request successful", :code => 200
  ##~ op.errorResponses.add :message => "Harp, output not found", :code => 404
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  get '/output/:harp_id/:output_token' do
    context = prepare_context(params)
    interpreter = Harp::HarpInterpreter.new(context)
    get_output(params[:output_token], interpreter, context)
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/status/{harp_id}"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "Get the status of a harp script."
  ##~ op.nickname = "get_status"
  ##~ op.parameters.add :name => "harp_id", :description => "Harp script execution ID", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Request successful", :code => 200
  ##~ op.errorResponses.add :message => "Harp not found", :code => 404
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  get '/status/:harp_id' do
    context = prepare_context(params)
    interpreter = Harp::HarpInterpreter.new(context)
    run_lifecycle("FIXME", interpreter, context)
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/{lifecycle}/{harp_id}"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke a particular lifecycle operation on a harp script."
  ##~ op.nickname = "run_lifecycle"
  ##~ op.parameters.add :name => "lifecycle", :description => "Lifecycle action to take (create, etc.)", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "harp_id", :description => "Harp script execution ID", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/:lifecycle/:harp_id' do
    context = prepare_context(params)
    interpreter = Harp::HarpInterpreter.new(context)
    run_lifecycle(params[:lifecycle], interpreter, context)
  end

end
