require 'test_helper'

module Hydrogen
  module IntegrationTests
    class GeneratorsTest < MiniTest::Unit::TestCase

      def test_generators_are_invoked_with_the_proper_args
        generator = Class.new Hydrogen::Generator do
          def self.full_name
            "foo"
          end
        end

        generator.expects(:start).with(["bar", "baz"], {}).returns(:invoked)

        cli = Class.new Hydrogen::CLI

        result = cli.start ["g", "foo", "bar", "baz"]

        assert_equal :invoked, result
      end

      def test_switches_are_passed_to_generator
        generator = Class.new Hydrogen::Generator do
          def self.full_name
            "foo"
          end
        end

        generator.expects(:start).with(["bar", "--quick"], {}).returns(:invoked)

        cli = Class.new Hydrogen::CLI

        result = cli.start ["g", "foo", "bar", "--quick"]

        assert_equal :invoked, result
      end
    end
  end
end
