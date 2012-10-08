module Hydrogen
  class UnknownGenerator < Error ; end

  module Generators
    def self.subclasses
      @subclasses ||= []
    end

    def self.invoke(name, args = ARGV, config = {})
      if klass = find(name)
        klass.start args, config
      else
        raise "Could not find #{namespace}!"
      end
    end

    def self.find(name)
      lookups = []
      lookups << name
      lookups << "#{name}:#{name}"

      lookup(lookups)

      generators = Hash[subclasses.map { |klass| [klass.full_generator_name, klass] }]

      lookups.each do |generator|
        klass = generators[generator]
        return klass if klass
      end

      return nil
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
