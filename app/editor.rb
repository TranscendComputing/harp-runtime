require 'sinatra/base'
require 'logging'
require 'erb'

class EditorApp < Sinatra::Base

  include ERB::Util

  before do
    headers "Content-Type" => "text/html; charset=utf-8"
  end

  get '/' do
    sample_file = params[:sample] || "default.harp"
    if sample_file
      file = File.open(File.join(File.dirname(__FILE__), "../sample/#{sample_file}"))
      @content = file.read
    else
      @content = ''
    end
    @require_main = "editor"
    @editor = true
    erb :editor
  end

end
