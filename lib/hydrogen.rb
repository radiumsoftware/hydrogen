require "hydrogen/version"

require "thor"

module Hydrogen
  class Error < StandardError ; end
  class IncorrectRoot < Error ; end
  class UnknownCommandName < Error ; end
end

require "hydrogen/utils"
require "hydrogen/path_set"
require "hydrogen/component"
require "hydrogen/command"
require "hydrogen/cli"
require "hydrogen/generator"
require "hydrogen/generators"
require "hydrogen/application"
