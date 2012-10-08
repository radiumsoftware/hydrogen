require "test_helper"

class Hydrogen::GeneratorsTest < MiniTest::Unit::TestCase
  def test_generator_lookup_against_full_name
    generator = Class.new do
      def self.full_name
        "foo"
      end
    end

    Hydrogen::Generators.subclasses << generator

    generator.expects(:start).returns(:invoked)

    result = Hydrogen::Generators.invoke "foo"
    assert_equal :invoked, result
  ensure
    Hydrogen::Generators.subclasses.clear
  end
end
