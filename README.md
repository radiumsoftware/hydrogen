# Hydrogen

Hydrogen is a framework for building extendable Ruby programs. It
enables other ruby programs to tie into another for configuration
purposes. You should use hydrogen if your program needs to be customized
by external code. Hydrogen allows your main application and external
applications to:

1. Customize sets of file paths
2. Load generators
3. Load rake tests
4. Load code for CLI access
5. Enable 3rd party code to extend the main application
6. Enable callbacks to 3rd party code

## Writing Commands

Commands are individual Thor classes that implement small bits of
functionality. Components can load commands. Loaded commands will be
accessible via a `Hydrogen::CLI` class.

Here's an example:

```ruby
# First: write your command
class HelloWorld < Hydrogen::Command
  # thor stuff
  def hello(msg)
    puts msg
  end
end

# Second: connect it with a component
# greeter.rb
class Greeter < Hydrogen::Component
  command HelloWorld, :hello, description, help
end

# Third: setup the CLI
# cli.rb
require 'hydrogen'
require 'gretter' # loads the greeter component

class MyCLI < Hydrogen::CLI

end

MyCLI.run
```

```
# Finally in the shell
$ ruby ./cli hello Adam
```

Now any number of external or internal libraries can augment your main
CLI. All CLI classes inherit from Thor so everything is available.

## Adding Paths

Components may also specify paths for use in other components. These
paths don't mean anything initially. The API is abstract. You should use
it as a low layer to build upon.

```
class AutoLoader < Hydrogen::Component
  # The key presents the purpose
  paths[:images].add "lib/images" # add a directory
  paths[:images].add "icons", :glob => "*.png" # add files
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
