# Author::    John Gardner
# Copyright:: Copyright (c) 2013 Transcend Computing
# License::   ASLV2

module Harp

  require "json"
  require "rgl/adjacency"
  require "rgl/topsort"

  # Resourcer keeps track of defined resources and provides lookup over them.
  class Resourcer

    @@logger = Logging.logger[self]

    def initialize(harp_id)
      @dep_graph = RGL::DirectedAdjacencyGraph[]
      @dependencies = Hash.new []
      @harp_id = harp_id
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

    # Retrieve a resource definition from the set
    def get_existing(resource_name)
      @@logger.debug "Looking for resource: #{resource_name}."
      @resources[resource_name]
    end

    # Retrieve a resource dependency list from the set
    def get_dep(resource_name)
      @@logger.debug "Looking for : #{resource_name}'s dependencies"
      @dependencies[resource_name]
    end

    private

    def digest(content)
      json = JSON.parse(content)
      @config = json.has_key?("Config") ? json["Config"] : nil
      @resources = json.has_key?("Resources") ? json["Resources"] : nil
      parse_into_graph
    end


    def parse_into_graph
      @resources.each do |name, content|
        match_deps(name, content, "ref")
      end
      unless @dep_graph.acyclic?
          raise "Found circular dependency"
      end
    end

    #Iterate over values to check for specified item
    def match_deps(name, content, item)
      content.each do |key, value|
        if value.is_a?(Hash)
            dep = value[item]
            unless dep.nil?
              content[key] = @resources.has_key?(dep) ? @resources[dep]["id"] : nil
              @dependencies[name] += [dep]
              @dep_graph.add_edge(dep, name)
            end
        end
    end
      
    end

  end
end