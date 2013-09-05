require 'rubygems'

class HarpApiApp < ApiBase
  ##~ sapi = source2swagger.namespace("harp")
  ##~ sapi.swaggerVersion = "1.2"
  ##~ sapi.apiVersion = "1.0.0"
  ##~ sapi.basePath = "http://localhost:9393"
  ##~ sapi.resourcePath = "/api/v1/harp"

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/create"
  ##~ a.description = "Harp runtime invocation of create"

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "Invoke normal create lifecycle"
  ##~ op.nickname = "run_create"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  get '/create' do
    access = params[:access] || ""
    secret = params[:secret] || ""
    script = request.body.read

    context = { :access => access, :secret => secret }
    interpreter = Harp::HarpInterpreter.new(context)

    # TODO: supply POST body as script.
    context[:harp_file] = "sample/basic_webapp.harp"
    results = interpreter.play(Harp::Lifecycle::CREATE, context)
    erb :harp_api_result,  :layout => :layout_api, :locals => {:lifecycle => params[:lifecycle], :results => results}
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/{lifecycle}"
  ##~ a.description = "Harp runtime invocation"

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "GET"
  ##~ op.summary = "List lifecycle stages supported"
  ##~ op.nickname = "get_lifecycle"
  ##~ op.parameters.add :name => "lifecycle", :description => "Lifecycle action to take (create, etc.)", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  get '/:lifecycle' do
    access = params[:access] || ""
    secret = params[:secret] || ""
    script = request.body.read
    if params.key?("lifecycle")
      puts "Got #{params[:lifecycle]}"
    end

    context = { :access => access, :secret => secret }
    interpreter = Harp::HarpInterpreter.new(context)

    # TODO: supply POST body as script.
    context[:harp_file] = "sample/basic_webapp.harp"
    results = interpreter.play(params[:lifecycle], context)
    erb :harp_api_result,  :layout => :layout_api, :locals => {:lifecycle => params[:lifecycle], :results => results}
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/{lifecycle}"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke a particular lifecycle operation on a harp script."
  ##~ op.nickname = "run_lifecycle"
  ##~ op.parameters.add :name => "lifecycle", :description => "Lifecycle action to take (create, etc.)", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/:lifecycle' do

    access = params[:access] || ""
    secret = params[:secret] || ""
    script = request.body.read
    if params.key?("lifecycle")
      puts "Got #{params[:lifecycle]}"
    end

    context = { :access => access, :secret => secret }
    interpreter = Harp::HarpInterpreter.new(context)

    # TODO: supply POST body as script.
    context[:harp_file] = "sample/basic_webapp.harp"
    results = interpreter.play(params[:lifecycle], context)
    erb :harp_api_result,  :layout => :layout_api, :locals => {:lifecycle => params[:lifecycle], :results => results}
  end

end