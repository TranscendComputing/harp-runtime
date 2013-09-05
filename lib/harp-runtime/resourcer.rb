# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2

module Harp

  require 'JSON'

  # Resourcer keeps track of defined resources and provides lookup over them.
  class Resourcer

    @@logger = Logging.logger[self]

    def initialize
    end

    # Accept the resources from a source and add to the dictionary of resources
    # available.
    def consume(template_or_uri)
      # TODO: handle URL
      @@logger.info "Consume template: #{template_or_uri.length.to_s}"
      JSON.parse(template_or_uri)
    end

    # Create a resource and wait for the resource to become available.
    def find(resource_name)
      @@logger.debug "Looking for resource: #{resource_name}."
    end

  end

end