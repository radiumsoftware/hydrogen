module Hydrogen
  class Component
    class << self
      def configure(&block)
        class_eval(&block)
      end

      def loaded
        @loaded ||= []
      end

      def called_from
        @called_from
      end

      def called_from=(path)
        @called_from = path
      end

      def inherited(base)
        loaded << base
        base.called_from = File.dirname(caller[1].sub(%r{:\d+.*}, ''))
      end

      def config
        instance.config
      end

      def instance
        @instance ||= new
      end

      def command(klass, name = nil)
        if klass.to_s =~ /Command$/
          klass_name = Utils.class_name(klass).match(/(.+)Command$/)[1]
          name = Utils.underscore klass_name
        elsif name.nil? || name.empty?
          raise UnknownCommandName
        end

        commands << { :class => klass, :name => name }
      end

      def commands
        config.commands
      end

      def paths
        instance.paths
      end

      def callbacks
        instance.callbacks
      end

      def callback(name, &block)
        key = name.to_sym
        callbacks[name] ||= []
        callbacks[name].push block
      end
    end

    def config
      @config ||= Configuration.new
    end

    def paths
      @paths ||= PathSet.new root
    end

    def root
      @root ||= find_root_with_flag("lib")
    end

    def callbacks
      config.callbacks
    end

    def configure(&block)
      self.class.configure &block
    end

    def run_callbacks(event)
      callbacks[event.to_sym].each do |callback|
        callback.call self
      end
    end

    private
    # Shamelessly taken from rails
    def find_root_with_flag(flag, default=nil)
      root_path = self.class.called_from

      while root_path && File.directory?(root_path) && !File.exist?("#{root_path}/#{flag}")
        parent = File.dirname(root_path)
        root_path = parent != root_path && parent
      end

      root = File.exist?("#{root_path}/#{flag}") ? root_path : default
      raise CouldNotFindRoot, "Could not find root path for #{self}" unless root

      RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ?
        Pathname.new(root).expand_path : Pathname.new(root).realpath
    end
  end
end
