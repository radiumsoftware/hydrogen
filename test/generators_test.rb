require "test_helper"

class Hydrogen::GeneratorsTest < MiniTest::Unit::TestCase
  def setup
    $LOAD_PATH << sandbox_path.to_s
    super
  end

  def teardown
    $LOAD_PATH.pop
    super
  end

  def make_generator(path, content)
    full_path = "#{sandbox_path}/#{path}"
    FileUtils.mkdir_p File.dirname(full_path)

    File.open(full_path, "w") { |f| f.puts content }
  end

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
  end

  def test_generator_blows_up_on_missing_generator
    assert_raises Hydrogen::MissingGenerator do
      Hydrogen::Generators.invoke "this:does:not:exist"
    end
  end

  def test_generator_name_lookup
    make_generator "soda/sprite_generator.rb", <<-content
      module Soda
        class SpriteGenerator
          def self.full_name
            "soda:sprite"
          end

          def self.start(*args)
            :invoked
          end

          Hydrogen::Generators.subclasses << Soda::SpriteGenerator
        end
      end
    content

    result = Hydrogen::Generators.invoke "soda:sprite"
    assert_equal :invoked, result
  end

  def test_generator_name_lookup_with_default_namespace
    make_generator "hydrogen/atoms/proton_generator.rb", <<-content
      module Hydrogen
        module Atoms
          class ProtonGenerator
            def self.full_name
              "hydrogen:atoms:proton"
            end

            def self.start(*args)
              :invoked
            end

            Hydrogen::Generators.subclasses << Hydrogen::Atoms::ProtonGenerator
          end
        end
      end
    content

    result = Hydrogen::Generators.invoke "atoms:proton"
    assert_equal :invoked, result
  end

  def test_generator_is_not_required_in_the_filename
    make_generator "hydrogen/atoms/electron.rb", <<-content
      module Hydrogen
        module Atoms
          class Electron
            def self.full_name
              "hydrogen:atoms:electron"
            end

            def self.start(*args)
              :invoked
            end

            Hydrogen::Generators.subclasses << Hydrogen::Atoms::Electron
          end
        end
      end
    content

    result = Hydrogen::Generators.invoke "atoms:electron"
    assert_equal :invoked, result
  end
end
