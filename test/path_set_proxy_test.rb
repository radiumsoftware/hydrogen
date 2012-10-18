require 'test_helper'

class PathSetProxyTest < MiniTest::Unit::TestCase
  def test_implements_path_lookup
    my_paths = Hydrogen::PathSet.new(__FILE__)
    vendor_paths = Hydrogen::PathSet.new(__FILE__)

    my_paths[:js].add "app"
    vendor_paths[:js].add "vendor"

    proxy = Hydrogen::PathSetProxy.new [my_paths, vendor_paths]

    assert_includes proxy[:js], my_paths[:js]
    assert_includes proxy[:js], vendor_paths[:js]
  end

  def test_implements_path_expansion
    my_paths = Hydrogen::PathSet.new(__FILE__)
    vendor_paths = Hydrogen::PathSet.new(__FILE__)

    my_paths[:js].add "app"
    vendor_paths[:js].add "vendor"

    proxy = Hydrogen::PathSetProxy.new [my_paths, vendor_paths]

    assert_includes proxy[:js].expanded, my_paths[:js].expanded.first
    assert_includes proxy[:js].expanded, vendor_paths[:js].expanded.first
  end
end
