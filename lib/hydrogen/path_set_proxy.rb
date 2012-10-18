module Hydrogen
  class PathSetProxy
    def initialize(items)
      @items = items
    end

    def [](*args)
      self.class.new(forward(:[], *args))
    end

    def expanded
      forward(:expanded).flatten.uniq
    end
    alias to_a expanded

    def include?(object)
      @items.include? object
    end

    private
    def forward(name, *args, &block)
      @items.collect do |item|
        item.send name, *args, &block
      end
    end
  end
end
