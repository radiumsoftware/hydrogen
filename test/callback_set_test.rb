require 'test_helper'

class CallbackSetTest < MiniTest::Unit::TestCase
  def test_callbacks_can_specify_options_for_all_callbacks
    set = Hydrogen::CallbackSet.new [], :type => :test
    set.add { }
    assert_equal :test, set.to_a.first.options[:type]
  end

  def test_callbacks_can_specify_after
    results = []

    set = Hydrogen::CallbackSet.new

    set.add "foo.bar", :after => "bar.baz" do
      results << "foo.bar"
    end

    set.add "bar.baz" do
      results << "bar.baz"
    end

    set.invoke

    assert_equal ["bar.baz", "foo.bar"], results
  end

  def test_callbacks_can_specify_before
    results = []

    set = Hydrogen::CallbackSet.new

    set.add "foo.bar" do
      results << "foo.bar"
    end

    set.add "bar.baz", :before => "foo.bar" do
      results << "bar.baz"
    end

    set.invoke

    assert_equal ["bar.baz", "foo.bar"], results
  end

  def test_runs_callbacks_in_order_if_none_given
    results = []

    set = Hydrogen::CallbackSet.new

    set.add "foo.bar" do
      results << "foo.bar"
    end

    set.add "bar.baz" do
      results << "bar.baz"
    end

    set.invoke

    assert_equal ["foo.bar", "bar.baz"], results
  end

  def test_callbacks_without_order_are_last
    results = []

    set = Hydrogen::CallbackSet.new

    set.add "a" do
      results << "a"
    end

    set.add "b", :before => "a" do
      results << "b"
    end

    set.add "c", :after => "a" do
      results << "c"
    end

    set.invoke

    assert_equal %w(b a c), results
  end

  def test_callbacks_without_order_are_invoked_in_declared_order
    results = []

    set = Hydrogen::CallbackSet.new

    set.add "a" do
      results << "a"
    end

    set.add "b" do
      results << "b"
    end

    set.add "c" do
      results << "c"
    end

    set.invoke

    assert_equal %w(a b c), results
  end

  def test_filtering_callbacks_returns_a_new_set
    results = []

    set = Hydrogen::CallbackSet.new

    set.add "a", :type => :foo do
      results << "a"
    end

    set.add "b" do
      results << "b"
    end

    set.add "c", :type => :foo do
      results << "c"
    end

    set = set.filter { |c| c.options[:type] == :foo }

    set.invoke

    assert_equal %w(a c), results
  end

  def test_array_like_interface
    set = Hydrogen::CallbackSet.new
    assert_equal 0, set.size

    set.add "foo" do 

    end
    assert_equal 1, set.size

    set.clear
    assert_empty set
  end

  def test_raise_an_error_when_block_given
    set = Hydrogen::CallbackSet.new
    assert_raises RuntimeError do
      set.add "foo"
    end
  end
end
