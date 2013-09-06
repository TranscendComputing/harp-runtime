# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2

module Harp

  require 'JSON'

  # Resourcer keeps track of defined resources and provides lookup over them.
  class Resourcer

    @@logger = Logging.logger[self]

    def initialize
      @resources = nil
      @config = nil
    end

    # Accept the resources from a source and add to the dictionary of resources
    # available.
    def consume(template_or_uri)
      # TODO: handle URL
      @@logger.info "Consume template: #{template_or_uri.length.to_s}"
      digest(template_or_uri)
    end

    # Retrieve a resource definition from the set
    def get(resource_name)
      @@logger.debug "Looking for resource: #{resource_name}."
      @resources[resource_name]
    end

    private

    def digest(content)
      json = JSON.parse(content)
      @config = json.has_key?("Config") ? json["Config"] : nil
      @resources = json.has_key?("Resources") ? json["Resources"] : nil
    end
  end

end