require "test_helper"

class Hydrogen::GeneratorTest < MiniTest::Unit::TestCase
  def test_inheriting_loads_it_the_known_set
    generator = Class.new Hydrogen::Generator 

    assert_includes Hydrogen::Generators.subclasses, generator
  end

  def test_generator_full_name_includes_namespace
    generator = Class.new Hydrogen::Generator do
      namespace :coke
    end

    assert_match /^coke\:/, generator.full_name
  end

  def test_generator_full_name_includes_the_name
    generator = Class.new Hydrogen::Generator do
      def self.generator_name
        "coke"
      end
    end

    assert_match /\:coke$/, generator.full_name
  end

  def test_generator_full_name
    generator = Class.new Hydrogen::Generator do
      namespace :coca

      def self.generator_name
        "cola"
      end
    end

    assert_equal "coca:cola", generator.full_name
  end

  class Soda < Hydrogen::Generator ; end
  def test_generator_name_does_not_include_namespace
    assert_equal "soda", Soda.generator_name
  end

  class MoneyGenerator < Hydrogen::Generator ; end
  def test_generator_name_does_not_include_generator 
    assert_equal "money", MoneyGenerator.generator_name
  end

  def test_generator_name_uses_class_namespace_by_default
    generator = Class.new Hydrogen::Generator do
      def self.to_s
        "Beer::Dark"
      end
    end

    assert_equal "beer:dark", generator.full_name
  end
end
