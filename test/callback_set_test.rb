require 'test_helper'

class CallbackSetTest < MiniTest::Unit::TestCase
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
end
