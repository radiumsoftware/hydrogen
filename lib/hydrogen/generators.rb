module Hydrogen
  class MissingGenerator < Error ; end

  module Generators
    def self.subclasses
      @subclasses ||= []
    end

    def self.invoke(name, args = ARGV, config = {})
      if klass = find(name)
        klass.start args, config
      else
        raise MissingGenerator, "Could not find #{name}!"
      end
    end

    def self.find(name)
      lookup [name]

      subclasses.find do |klass|
        klass.full_name == name
      end
    end

    def self.lookup(namespaces)
      paths = namespaces_to_paths(namespaces)

      paths.each do |raw_path|
        ["generators"].each do |base|
          path = "#{base}/#{raw_path}_generator"

          begin
            require path
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
