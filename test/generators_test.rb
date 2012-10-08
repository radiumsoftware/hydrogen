require "test_helper"

class Hydrogen::GeneratorsTest < MiniTest::Unit::TestCase
  def invoke(*args)
    Hydrogen::Generators.invoke *args
  end

  def teardown
    Hydrogen::Generators.subclasses.clear
  end

  def test_generator_lookup_against_full_name
    generator = Class.new do
      def self.full_generator_name
        "foo"
      end
    end

    Hydrogen::Generators.subclasses << generator

    generator.expects(:start).returns(:invoked)

    result = invoke "foo"
    assert_equal :invoked, result
  end
end
