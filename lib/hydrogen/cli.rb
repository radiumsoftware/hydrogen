module Hydrogen
  class CLI < Thor
    class << self
      def inherited(base)
        base.add_subcommands! base
      end

      def add_subcommands!(cli, components = Component.loaded)
        components.each do |component|
          component.commands.each do |hash|
            command_class, command_name = hash[:class], hash[:name]
            cli.register command_class, command_name, "#{name} ARGS", command_class.description
          end
        end
      end
    end

    desc "generate NAME ARGS", "run the given generator"
    def generate(name, *args)
      Hydrogen::Generators.invoke name, args
    end
  end
end
