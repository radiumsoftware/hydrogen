require 'thor'
require 'thor/group'

module Hydrogen
  class Generator < Thor::Group
    include Thor::Actions

    def self.inherited(base)
      super
      Hydrogen::Generators.subclasses << base
    end

    def self.namespace(name=nil)
      return super if name

      class_namespace = to_s.split('::').first
      @namespace ||= Utils.underscore(class_namespace) if class_namespace
    end

    def self.generator_name
      @generator_name ||= begin
        if generator = to_s.split('::').last
          generator.sub!(/Generator$/, '')
          Utils.underscore generator
        end
      end
    end

    def self.full_name
      "#{namespace}:#{generator_name}"
    end

    def self.source_root(path = nil)
      @_source_root = path if path
      @_source_root ||= default_source_root
    end

    def self.default_source_root
      File.expand_path(File.join(namespace, generator_name, "templates"), base_root)
    end

    def self.base_root
      File.dirname(__FILE__)
    end
  end
end
