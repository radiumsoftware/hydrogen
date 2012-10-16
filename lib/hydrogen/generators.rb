module Hydrogen
  class MissingGenerator < Error ; end

  module Generators
    def self.subclasses
      @subclasses ||= []
    end

    def self.default_namespaces
      ["hydrogen"]
    end

    def self.invoke(name, args = ARGV, config = {})
      if klass = find(name)
        klass.start args, config
      else
        raise MissingGenerator, "Could not find #{name}!"
      end
    end

    def self.find(name)
      lookups = []
      lookups << name

      default_namespaces.each do |_namespace|
        lookups << "#{_namespace}:#{name}"
      end

      lookup lookups

      subclasses.find do |klass|
        lookups.include? klass.full_name
      end
    end

    def self.lookup(namespaces)
      paths = namespaces_to_paths(namespaces)

      paths.each do |path|
        tries = [
          path,
          "#{path}_generator"
        ]

        tries.each do |full_path|
          begin
            require full_path
            return
          rescue LoadError
            # nothing
          end
        end
      end
    end

    def self.namespaces_to_paths(namespaces)
      namespaces.collect do |namespace|
        namespace.gsub ":", "/"
      end.uniq
    end
  end
end
