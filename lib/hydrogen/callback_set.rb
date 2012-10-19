module Hydrogen
  class CallbackSet
    class Collection < Array
      include TSort

      def tsort_each_child(callback, &block)
        select { |c| c.before == callback.name || c.name == callback.after }.each(&block)
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
      @set.tsort.each do |callback|
        callback.invoke *args
      end
    end

    def filter
      matches = @set.select do |callback|
        yield callback
      end

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
