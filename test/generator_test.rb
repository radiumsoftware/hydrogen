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

  def test_source_root_includes_namespace_and_name
    generator = Class.new Hydrogen::Generator do
      namespace :foo

      def self.to_s
        "Bar"
      end
    end

    assert_match generator.source_root, %r{foo/bar/templates}
  end

  def test_source_root_does_not_include_generator
    generator = Class.new Hydrogen::Generator do
      namespace :foo

      def self.to_s
        "BarGenerator"
      end
    end

    assert_match generator.source_root, %r{foo/bar/templates}
  end

  def test_source_root_is_based_off_base_root
    generator = Class.new Hydrogen::Generator do
      namespace :foo

      def self.to_s
        "Bar"
      end

      def self.base_root
        "/generators"
      end
    end

    assert_equal "/generators/foo/bar/templates", generator.source_root
  end

  def test_source_root_can_be_called_normally
    generator = Class.new Hydrogen::Generator do
      source_root :foo
    end

    assert_equal :foo, generator.source_root
  end
end
