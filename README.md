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
class GreetCommand < Hydrogen::Command
  # This is a general description used by thor
  # when the main help command is run
  description "Says hello"

  desc "hello MSG", "print the hello message"
  def hello(msg)
    puts msg
  end
end

# Second: connect it with a component
# greeter_component.rb
class GreeterComponent < Hydrogen::Component
  # classes ending in Command will use the snake case 
  # version of the first part for the command name.
  command GreetCommand
end

# Third: setup the CLI
# cli.rb
require 'hydrogen'
require 'greeter' # loads the greeter component

class MyCLI < Hydrogen::CLI

end

MyCLI.start
```

```
# Finally in the shell
$ ruby ./cli greet hello Adam
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

## Writing Generators

Third party code and include generators. Generators are invoked through
a `Hydrogen::CLI`. Generators are subclasses of `Hydrogen::Generator`.
Each generator defines a `full_name` method. This method is used to
lookup generators via the CLI. The `full_name` is the `namespace` and
the `name` by default. Override these methods if you like. Here's an
example.

```ruby
# Create a generator
class FooGenerator < Hydrogen::Generator
  def self.full_name
    "foo:bar:baz"
  end
end

# Now assume you have a simple CLI Ready
# cli.rb
class CLI < Hydrogen::CLI ; end

CLI.start
```

At this point you can run your generator:

```
$ cli generate foo:bar:baz
```

It is awkward to define the `full_name` method all the time. You can
avoid this by following naming conventions. Here are some example:

```
Foo::Bar::BazGenerator => foo:baz
Foo::Bar::Baz => foo:baz
```

You can also set a custom namespace if you like:

```ruby
# This class can be invoked with "ember:foo"

class FooGenerator < Hydrogen::Generator
  namespace :ember
end
```

You may also redfine the name if you like. This is the class name
without "Generator" by default.

```ruby
# This class can be invoked with "ember:adam"

class FooGenerator < Hydrogen::Generator
  namespace :ember

  def self.name
    "model"
  end
end
```

If you don't care about any of this stuff then you can simply leave
things as and they will work more or less as you expect.

Generators may also be invoked via a default namespace. This is used
when you want your bundled generators to be invokable without a
namespace but namespaced in code. A real life is example is: `rails g
model` vs `rails g rspec:setup`. The default namespace is `hydrogen`.
Here's an example:

```ruby
module Hydrogen
  class FooGenerator < Generator
  end
end
```

You can invoke this generator by `cli g foo` or `cli g hydrogen:foo`.
You can redfine the default namespace by defining
`Hydrogen::Generators.default_namespace`.

### Structuring Generators

Generators are required at invokation time so their
file names need to follow a convention. Assume `/` in the following
example is on `$LOAD_PATH`.

```
/hydrogen/generators/name_generator.rb
/hydrogen/generators/name.erb
/namespace/generator/name.rb
/namespace/generator/name_generator.rb
```

### Generator Templates

The `source_root` for generators is also prefined for you. Its also
based on the class name. Say you have this generator:

```ruby
# /ember/model_generator.rb
class Ember::ModelGenerator < Hydrogen::Generator

end
```

Your templates directory would be `/ember/model/templates`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
