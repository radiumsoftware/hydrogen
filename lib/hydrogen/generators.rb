module Hydrogen
  class UnknownGenerator < Error ; end

  module Generators
    def self.subclasses
      @subclasses ||= []
    end

    def self.implicit_namespace
      "hydrogen"
    end

    def self.invoke(namespace, args = ARGV, config = {})
      names = namespace.to_s.split(':')
      if klass = find_by_namespace(names.pop, names.any? && names.join(':'))
        klass.start args, config
      else
        raise "Could not find #{namespace}!"
      end
    end

    def self.find_by_namespace(name, base = nil, context = nil)
      lookups = []
      lookups << "#{base}:#{name}"    if base
      lookups << "#{name}:#{context}" if context

      unless base || context
        unless name.to_s.include?(?:)
          lookups << "#{name}:#{name}"
          lookups << "#{implicit_namespace}:#{name}"
        end
        lookups << "#{name}"
      end

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
        ["#{implicit_namespace}/generators", "generators"].each do |base|
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
      paths = []
      namespaces.each do |namespace|
        pieces = namespace.split(":")
        paths << pieces.dup.push(pieces.last).join("/")
        paths << pieces.join("/")
      end
      paths.uniq!
      paths
    end
  end
end
