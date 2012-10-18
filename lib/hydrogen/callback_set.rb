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

      def ordered?
        before || after
      end
    end

    def initialize(callbacks = [])
      @set = Collection.new(callbacks)
    end

    def add(*args, &block)
      options = Utils.extract_options! args
      name = args.shift
      @set << Callback.new(name, options, &block)
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
  end
end
