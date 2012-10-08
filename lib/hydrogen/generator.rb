require 'thor'
require 'thor/group'

module Hydrogen
  class Generator < Thor::Group
    def self.inherited(base)
      super
      Hydrogen::Generators.subclasses << base
    end

    def self.namespace(name=nil)
      return super if name
      @namespace ||= super.sub(/_generator$/, '').sub(/:generators:/, ':')
    end

    def self.generator_name
      @generator_name ||= begin
        if generator = name.to_s.split('::').last
          generator.sub!(/Generator$/, '')
          Utils.underscore generator
        end
      end
    end

    def self.full_generator_name
      "#{namespace}:#{generator_name}"
    end
  end
end
