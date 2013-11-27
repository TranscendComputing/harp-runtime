require 'sinatra/base'
require 'logging'

class EditorApp < Sinatra::Base

  before do
    headers "Content-Type" => "text/html; charset=utf-8"
  end

  get '/' do
    @require_main = "editor"
    @editor = true
    erb :editor
  end

end
