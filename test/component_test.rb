require 'test_helper'

class Hydrogen::ComponentTest < MiniTest::Unit::TestCase
  def test_components_share_the_same_config
    carb = Class.new Hydrogen::Component do
      config.foo = :bar
    end

    manifold = Class.new Hydrogen::Component do
      config.bar = :baz
    end

    assert_equal :bar, manifold.config.foo
    assert_equal :baz, carb.config.bar
  end

  def test_inheriting_from_a_components_records_it
    header = Class.new Hydrogen::Component

    assert_includes Hydrogen::Component.loaded, header
  end

  def test_components_can_register_commands
    receive_mail = Class.new Hydrogen::Command do
      description "Receives incoming mail"
    end

    deliver_mail = Class.new Hydrogen::Command do
      description "Delivers mails"
    end

    post_office = Class.new Hydrogen::Component do
      command receive_mail, :receive
      command deliver_mail, :deliver
    end

    assert_equal 2, post_office.commands.size
  end

  def test_command_names_happen_by_convention
    properly_named_command = Class.new do
      class << self
        def to_s
          "Namespaced::Name::CompileCommand"
        end
      end
    end

    component = Class.new Hydrogen::Component do
      command properly_named_command
    end

    command = component.commands.first
    assert_equal "compile", command[:name]
  end

  def test_command_raised_an_error_when_name_cannot_be_determined
    component = Class.new Hydrogen::Component

    assert_raises Hydrogen::UnknownCommandName do
      component.command Class.new
    end
  end

  def test_components_can_configure_paths
    asset_component = Class.new Hydrogen::Component do
      paths[:images].add "foo"
    end

    assert asset_component.paths
  end

  def test_multiple_components_dont_share_path_objects
    component1 = Class.new Hydrogen::Component do
      paths[:images].add "foo"
    end

    component2 = Class.new Hydrogen::Component do
      paths[:css].add "css"
    end

    refute_equal component1.paths, component2.paths
  end

  def test_components_have_callbacks
    component = Class.new Hydrogen::Component do
      callback :foo do 
        puts "Callback called!"
      end
    end

    assert_kind_of Hydrogen::CallbackSet, component.callbacks[:foo]
  end

  def test_callbacks_track_which_component_added_them
    component = Class.new Hydrogen::Component do
      callback :foo do 
        puts "Callback called!"
      end
    end

    assert component.callbacks[:foo]

    callback = component.callbacks[:foo].to_a.first
    assert_equal component, callback.options[:via]
  end

  def test_components_can_add_paths
    component = Class.new Hydrogen::Component do
      paths[:foo].add "bar"
    end

    base_path = Pathname.new(File.expand_path("../../", __FILE__))

    assert_equal [base_path.join("bar")], component.paths[:foo].expanded
  end

  def test_component_root
    component = Class.new Hydrogen::Component

    root_path = File.expand_path("../../", __FILE__)

    assert_kind_of Pathname, component.new.root
    assert_equal root_path, component.new.root.to_s
  end

  def test_components_can_be_configured
    component = Class.new Hydrogen::Component

    component.configure do 
      config.foo = :bar
    end

    assert_equal :bar, component.config.foo

    component.new.configure do
      config.foo = :baz
    end

    assert_equal :baz, component.config.foo
  end
end
