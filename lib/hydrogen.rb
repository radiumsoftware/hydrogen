require "hydrogen/version"

require "thor"

module Hydrogen
  class Error < StandardError ; end
  class IncorrectRoot < Error ; end
  class UnknownCommandName < Error ; end
  class CouldNotFindRoot < Error ; end
end

require "hydrogen/utils"
require "hydrogen/path_set"
require "hydrogen/path_set_proxy"
require "hydrogen/configuration"
require "hydrogen/component"
require "hydrogen/command"
require "hydrogen/cli"
require "hydrogen/generator"
require "hydrogen/generators"
