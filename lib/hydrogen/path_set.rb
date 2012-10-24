module Hydrogen
  class PathSet < ::Hash
    def initialize(root)
      @root = root

      raise Hydrogen::IncorrectRoot, "#{root} does not exist" unless File.exists? root

      super()
    end

    def [](key)
      if key? key
        fetch key
      else
        self.store key, Path.new(@root)
        fetch key
      end
    end

    class Path < ::Array
      class Entry < Struct.new(:path, :options)
        def glob
          if options[:glob].respond_to? :call
            options[:glob].call
          elsif options[:glob]
            options[:glob]
          end
        end
      end

      def initialize(root)
        @root = root
        super()
      end

      def add(path, options = {})
        push Entry.new(path, options)
      end

      def expanded
        results = map do |entry|
          base = File.expand_path entry.path, @root

          if entry.glob
            Dir["#{base}/#{entry.glob}"]
          else
            base
          end
        end.flatten.uniq

        results.map { |f| Pathname.new f }
      end
      alias to_a expanded

      def directories
        expanded.select { |f| File.directory? f }
      end

      def files
        expanded.select { |f| File.exists? f }
      end
    end
  end
end
