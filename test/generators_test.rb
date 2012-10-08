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

  def test_generator_lookup_works_with_default_namespace
    generator = Class.new do
      def self.full_name
        "#{Hydrogen::Generators.default_namespace}:foo"
      end
    end

    Hydrogen::Generators.subclasses << generator

    generator.expects(:start).returns(:invoked)

    result = Hydrogen::Generators.invoke "foo"
    assert_equal :invoked, result
  ensure
    Hydrogen::Generators.subclasses.clear
  end

  def test_generator_blows_up_on_missing_generator
    assert_raises Hydrogen::MissingGenerator do
      Hydrogen::Generators.invoke "this:does:not:exist"
    end
  end
end
