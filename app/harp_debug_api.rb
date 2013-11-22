require "sinatra/config_file"

# The Harp Debug API provides operations to step through a harp script and
# verify operations are correct, in the style of an Integrated Development
# Environment (IDE)
class HarpDebugApiApp < HarpApiApp

  before do
    @context[:debug] = true
    @interpreter = Harp::HarpInterpreter.new(@context)
  end

  ##~ sapi = source2swagger.namespace("harp-debug")
  ##~ sapi.swaggerVersion = "1.2"
  ##~ sapi.apiVersion = "0.1.0"
  ##~ sapi.basePath = "http://localhost:9393"
  ##~ sapi.resourcePath = "/api/v1/harp-debug"

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp-debug/create"
  ##~ a.description = "harp-debug runtime invocation of create"

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke create lifecycle, under debug"
  ##~ op.nickname = "run_debug_create"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/create' do
    run_lifecycle(Harp::Lifecycle::CREATE, @interpreter, @context)
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp-debug/destroy/{harp_id}"
  ##~ a.description = "Harp runtime invocation of destroy"

  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke normal destroy lifecycle, under debug"
  ##~ op.nickname = "run_debug_destroy"
  ##~ op.parameters.add :name => "harp_id", :description => "Harp script execution ID", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/destroy/:harp_id' do
    run_lifecycle(Harp::Lifecycle::DESTROY, @interpreter, @context)
  end

  ##~ a = sapi.apis.add
  ##~ a.set :path => "/api/v1/harp-debug/{lifecycle}"
  ##~ op = a.operations.add
  ##~ op.set :httpMethod => "POST"
  ##~ op.summary = "Invoke a particular lifecycle operation on a harp script, under debug."
  ##~ op.nickname = "run_debug_lifecycle"
  ##~ op.parameters.add :name => "lifecycle", :description => "Lifecycle action to take (create, etc.)", :dataType => "string", :allowMultiple => false, :required => true, :paramType => "path"
  ##~ op.parameters.add :name => "access", :description => "Cloud credential information, access key or user", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "secret", :description => "Secret key or password", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "auth", :description => "Cloud credential set to use, configured on server", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp_location", :description => "Harp script location (URI)", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "query"
  ##~ op.parameters.add :name => "harp", :description => "Harp script content", :dataType => "string", :allowMultiple => false, :required => false, :paramType => "body"
  ##~ op.errorResponses.add :message => "Invocation successful", :code => 200
  ##~ op.errorResponses.add :message => "Invocation successfully begun", :code => 202
  ##~ op.errorResponses.add :message => "Bad syntax in script", :code => 400
  ##~ op.errorResponses.add :message => "Unable to authorize with supplied credentials", :code => 401
  ##~ op.errorResponses.add :message => "Fatal error invoking script", :code => 500
  post '/:lifecycle' do
    run_lifecycle(params[:lifecycle], @interpreter, @context)
  end

end
