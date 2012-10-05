require "hydrogen/version"

require "thor"

require "hydrogen/path_set"
require "hydrogen/component"
require "hydrogen/command"
require "hydrogen/cli"
require "hydrogen/application"

module Hydrogen
  class Error < StandardError ; end
  class IncorrectRoot < Error ; end
end
