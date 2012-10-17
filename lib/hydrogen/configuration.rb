module Hydrogen
  class Configuration
    def initialize
      @@options ||= {}
      @@options[:commands] ||= []
      @@options[:callbacks] ||= {}
    end

    def commands
      @@options[:commands]
    end

    def respond_to?(name)
      super || @@options.key?(name.to_sym)
    end

    private
    def options
      @@options
    end

    def method_missing(name, *args, &blk)
      if name.to_s =~ /=$/
        @@options[$`.to_sym] = args.first
      elsif @@options.key?(name)
        @@options[name]
      else
        super
      end
    end
  end
end
