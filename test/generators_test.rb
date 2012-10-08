require "test_helper"

class Hydrogen::GeneratorsTest < MiniTest::Unit::TestCase
  def invoke(*args)
    Hydrogen::Generators.invoke *args
  end

  def test_generator_lookup_against_full_name
    generator = Class.new Hydrogen::Generator do
      def self.full_generator_name
        "foo"
      end
    end

    generator.expects(:start).returns(:invoked)

    result = invoke "foo"
    assert_equal :invoked, result
  end

  def test_generator_lookup_against_name_and_namespace
    generator = Class.new Hydrogen::Generator do
      namespace :ember

      def self.generator_name
        "foo"
      end
    end

    generator.expects(:start).returns(:invoked)

    result = invoke "ember:foo"
    assert_equal :invoked, result
  end

  def test_generator_namespace_can_be_nested
    generator = Class.new Hydrogen::Generator do
      namespace "ember:test"

      def self.generator_name
        "model"
      end
    end

    generator.expects(:start).returns(:invoked)

    result = invoke "ember:test:model"
    assert_equal :invoked, result
  end
end
