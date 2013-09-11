# The Harp API provides operations to deposit and invoke Harp scripts on the 
# Harp runtime.
class HarpApiApp < ApiBase
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
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/create' do
    access = params[:access] || ""
    secret = params[:secret] || ""
    harp_location = params[:harp_location] || nil
    script = request.body.read

    context = { :access => access, :secret => secret }
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true if params.key?("mock")
    interpreter = Harp::HarpInterpreter.new(context)

    if harp_location.nil?
      context[:harp_contents] = script
    else
      context[:harp_location] = harp_location
    end      
    results = interpreter.play(Harp::Lifecycle::CREATE, context)
    erb :harp_api_result,  :layout => :layout_api, :locals => {:lifecycle => params[:lifecycle], :results => results}
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp/destroy"
  ##~ a.description = "Harp runtime invocation of destroy"

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke normal destroy lifecycle"
  ##~ op.nickname = "run_destroy"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/destroy' do
    access = params[:access] || ""
    secret = params[:secret] || ""
    harp_location = params[:harp_location] || nil
    script = request.body.read

    context = { :access => access, :secret => secret }
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true if params.key?("mock")
    interpreter = Harp::HarpInterpreter.new(context)

    if harp_location.nil?
      context[:harp_contents] = script
    else
      context[:harp_location] = harp_location
    end      
    results = interpreter.play(Harp::Lifecycle::DESTROY, context)
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
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
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
      puts "post: Got #{params[:lifecycle]}"
    end

    context = { :access => access, :secret => secret }
    context[:cloud_type] = :aws # for the moment, assume AWS cloud
    context[:mock] = true if params.key?("mock")
    interpreter = Harp::HarpInterpreter.new(context)

    if harp_location.nil?
      context[:harp_contents] = script
    else
      context[:harp_location] = harp_location
    end      
    if script != nil and script.length < 1000
      logger.debug("Got harp script: #{script}")
    end
    begin
      results = interpreter.play(params[:lifecycle], context)
      erb :harp_api_result,  :layout => :layout_api, :locals => {:lifecycle => params[:lifecycle], :results => results}
    rescue => e
      logger.error("Error running script: #{e}")
      erb :harp_api_error,  :layout => :layout_api, :locals => {:lifecycle => params[:lifecycle], :error => "An error occurred."}
    end
  end

end
