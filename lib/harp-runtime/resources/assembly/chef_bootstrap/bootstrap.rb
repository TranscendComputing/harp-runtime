require 'rubygems'
require "chef"
require "chef/knife/core/bootstrap_context"
require 'chef/knife'
require 'chef/knife/ssh'
require 'net/ssh'
require 'net/ssh/multi'
require 'chef/knife/bootstrap'

Chef::Config.from_file(File.expand_path('<knife_path>'))
kb = Chef::Knife::Bootstrap.new
kb.name_args = "<server>"
kb.config[:identity_file] = "<identity_file_path>"
kb.config[:ssh_user] = "<ssh_user>"
kb.config[:ssh_password] = "<ssh_password>"
kb.config[:run_list] = ["recipe[apt]","recipe[<recipes>]"]
kb.config[:use_sudo] = true
kb.config[:use_sudo_password] = true
kb.config[:distro] = "chef-full"
kb.run