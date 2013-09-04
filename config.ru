# -*- coding: utf-8 -*-
# gems
require 'rubygems'
require 'bundler'

Bundler.require

# require the dependencies
$LOAD_PATH.unshift(File.dirname(__FILE__))
require File.join(File.dirname(__FILE__), 'app', 'init')
require 'app/root'
require 'app/harp'

# Following are Swagger directives, for REST API documentation.
##~ sapi = source2swagger.namespace("harp-runtime")
##~ sapi.swaggerVersion = "1.1"
##~ sapi.apiVersion = "1.0"

#
# Clouds API (internal)
#
##~ a = sapi.apis.add
##
##~ a.set :path => "/harp.{format}", :format => "json"
##~ a.description = "Harp runtime invocation"
map "/api/v1/harp" do
  run HarpApiApp
end

map '/' do
  run RootApp
end
