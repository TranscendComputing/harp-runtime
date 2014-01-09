require 'sinatra/base'
require 'logging'

class HarpUserApiApp < Sinatra::Base

  post '/key' do
    key = JSON.parse(request.body.read).symbolize_keys
    Key.create(key).to_json
  end

  get '/key/:key_name' do
    Key.get_by_name(params[:key_name]).to_json
  end

end
