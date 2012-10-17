require 'thor'
require 'thor/group'

module Hydrogen
  class Generator < Thor::Group
    include Thor::Actions

    class << self
      def inherited(base)
        super
        Hydrogen::Generators.subclasses << base
      end

      def namespace(name=nil)
        return super if name

        class_namespace = to_s.split('::').first
        @namespace ||= Utils.underscore(class_namespace) if class_namespace
      end

      def generator_name
        @generator_name ||= generator_class_name
      end

      def full_name
        "#{namespace}:#{generator_name}"
      end

      def source_root(path = nil)
        @_source_root = path if path
        @_source_root ||= default_source_root
      end

      def default_source_root
        File.expand_path(File.join(namespace, generator_class_name, "templates"), base_root)
      end

      def base_root
        File.dirname(__FILE__)
      end

      def generator_class_name
        generator = to_s.split('::').last
        generator.sub!(/Generator$/, '')
        Utils.underscore generator
      end
    end
  end
end
