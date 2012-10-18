require "bundler/setup"
require "simplecov"
SimpleCov.start

require "hydrogen"

require "debugger"

require "minitest/unit"
require "minitest/pride"
require "minitest/autorun"

require "mocha"

require "fileutils"
require "pathname"

module Hydrogen
  class Configuration
    def clear
      @@options.clear
    end
  end
end

class MiniTest::Unit::TestCase
  def setup
    FileUtils.mkdir_p sandbox_path
  end

  def teardown
    Hydrogen::Component.loaded.clear
    Hydrogen::Component.config.clear
    Hydrogen::Generators.subclasses.clear

    FileUtils.rm_rf sandbox_path if File.directory? sandbox_path
  end

  def sandbox_path
    Pathname.new(File.expand_path("../sandbox", __FILE__))
  end
end
