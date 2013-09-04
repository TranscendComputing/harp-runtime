# -*- coding: utf-8 -*-
# gems
require 'rubygems'
require 'bundler'

Bundler.require

# require the dependencies
$LOAD_PATH.unshift(File.dirname(__FILE__))
require File.join(File.dirname(__FILE__), 'app', 'init')
require 'app/root'

map '/' do
  run RootApp
end
