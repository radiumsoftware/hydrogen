require 'test_helper'

class Hydrogen::GeneratorsTest < MiniTest::Unit::TestCase
  def invoke(*args)
    stdout, stderr = capture_io do
      Hydrogen::Generators.invoke *args
    end
  end

  class MockGenerator < Hydrogen::Generator
    desc "say bar"
    def foo
      puts "bar"
    end
  end

  def test_generator_lookup_with_namespace_and_name
    generator = Class.new MockGenerator do
      namespace "ember"

      def self.generator_name
        "foo"
      end
    end

    stdout = invoke "ember:foo"
    assert_includes stdout.to_s, "bar"
  end
end
