module Hydrogen
  class CallbackSet
    class Collection < Array
      include TSort

      # group dependencies based on name. Names are optional so
      # we have to guard agains that case because it creates
      # circular dependencies
      def tsort_each_child(callback, &block)
        select do |c| 
          if !callback.name
            false
          else
            c.before == callback.name || c.name == callback.after
          end
        end.each(&block)
      end
      alias :tsort_each_node :each
    end

    class Callback
      attr_reader :name, :options

      def initialize(name, options = {}, &block)
        @name, @options, @block = name, options, block
      end

      def invoke(*args)
        @block.call *args
      end

      def before
        options[:before]
      end

      def after
        options[:after]
      end
    end

    def initialize(callbacks = [], default_options = {})
      @set = Collection.new(callbacks)
      @default_options = default_options
    end

    def add(*args, &block)
      raise "Block required" unless block

      options = Utils.extract_options! args
      name = args.shift
      @set << Callback.new(name, options.merge(@default_options), &block)
    end

    def invoke(*args)
      if block_given?
        filter { |cbk| yield cbk }.invoke *args
      else
        @set.tsort.each do |callback|
          callback.invoke *args
        end
      end
    end

    def filter
      matches = @set.select { |cbk| yield cbk }
      self.class.new matches
    end
    alias select filter

    def to_a
      @set.to_a
    end

    def clear
      @set.clear
    end

    def size
      @set.size
    end
    alias length size

    def empty?
      @set.empty?
    end
  end
end
