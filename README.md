# Obtions

### Build status

Develop:
[![Build Status](https://secure.travis-ci.org/samwho/obtions.png?branch=develop)](http://travis-ci.org/samwho/obtions)

Obtions was going to be the scratch to a personal itch that I have: I hate
using OptionParser to parse in command line arguments. The syntax feels a little
clunky, there are broken lines everywhere.

I wanted a library that was declarative and clear to understand, so I started
writing one. However, just as I was about to put a few finishing touches on the
library I found Chris Wanstrath's _excellent_
[Choice](https://github.com/defunkt/choice) library and all my efforts were
rendered unnecessary.

This repo lives because I didn't just want to throw the code I'd written away.
There are parts of this library that I prefer to Chris's and intend to submit
pull requests to him for them.

# Installation

Uhm, it's not a gem. I decided not to make it a gem because I wholeheartedly
think you should use [Choice](https://github.com/defunkt/choice) over Obtions.
If anyone expresses any distinct desire to use this library, I will gladly make
it into a gem and continue working on it but for now I think Choice is a
superior choice (hah, see what I did there?).

# Usage

If you _do_ want to use this library and you've pestered me into making it a
gem, here's how it works.

## Basic (flags)

Obtions aims to be declarative. Here's some basic syntax:

``` ruby
require 'obtions'

Obtions.parse do
  flag :s, long: "silent" do
    "Silences all log output."
  end
end
```

A silent flag is pretty common. The above example will parse `-s` or `--silent`
or `--no-silent` at the command line and reflect the results as a boolean value
on the `OpenStruct` object returned by `Obtions.parse`:

``` ruby
require 'obtions'

o = Obtions.parse "--silent" do
  flag :s, long: "silent" do
    "Silences all log output."
  end
end

o.silent? #=> true
o.silent  #=> true
o.s?      #=> true
o.s       #=> true
```

## Help documentation

Because all good command line programs should respond to `-h` and `--help`,
Obtions takes care of that automatically for you. Calling the above program with
the `-h` flag will cause the following output prompt:

```
Usage: test [options]
    -s, --[no-]silent                Silences all log output.
    -h, --help                       Show this message.
```

The banner ("Usage: test [options]") is generated automatically by the
OptionParser library that Obtions uses under the hood. The "test" part is pulled
from the file name. I used "test.rb" to test the example code.

Obtions uses the return value of blocks passed to each argument type as
documentation. In hindsight, this is incredibly limiting and one of the primary
reasons I stopped working on it. While it would not be difficult to change, I
can't see myself designing the API any different to
[Choice](https://github.com/defunkt/choice).

### Separators

Because Obtions is a thin veil over the top of OptionParser, we can define
separators with ease:

``` ruby
require 'obtions'

Obtions.parse do
  flag :d, long: :debug do
    "Enable debugging mode."
  end

  separator "Contrived separator ftw!"

  flag :s do
    "Silences all log output."
  end
end
```

Running that with `--help` gives us the following output:

```
Usage: test [options]
    -d, --[no-]debug                 Enable debugging mode.
Contrived separator ftw!
    -s                               Silences all log output.
    -h, --help                       Show this message.
```

### Banner

Again, Obtions gives you access to the banner if you need it:


``` ruby
require 'obtions'

Obtions.parse do
  banner "Usage: program [-d]"

  flag :d, long: :debug do
    "Enable debugging mode."
  end
end
```

Run with `-h` outputs:

```
Usage: program [-d]
    -d, --[no-]debug                 Enable debugging mode.
    -h, --help                       Show this message.
```

## Named arguments

Named arguments are the ones that start with two dashes, e.g. `--logfile` and
then are followed by an optional equals symbol (=) and a value. Obtions makes
them easy, here's an example:

``` ruby
require 'obtions'

Obtions.parse do
  named_arg :logfile
end
```

That will, as you might expect, give you access to a `.logfile` method with a
value specified by the user in the command line arguments. Not very exciting,
but we can go a step further with this example. Let's look at the following:

``` ruby
require 'obtions'

Obtions.parse do
  named_arg :logfile, default: "logs/error.log", type: File
end
```

We can guess with the default option does, but what about the type? What's that
going to do? Well, it's more or less what it says on the tin. The value we get
back is a file handle that we can read from:

``` ruby
require 'obtions'

o = Obtions.parse do
  named_arg :logfile, default: "logs/error.log", type: File
end

o.logfile.read  #=> whatever is in the file
o.logfile.class #=> File
```

This technique will through an `Errno::ENOENT` if the file does not exist.

### Other types

Obtions supports a range of other types. They're all pretty self explanatory,
check out this example:

``` ruby
require 'obtions'

o = Obtions.parse do
  named_arg :int,    type: Integer
  named_arg :float,  type: Float
  named_arg :binary, type: Integer, base: 2
  named_arg :hex,    type: Integer, base: 16
  named_arg :date,   type: Date, format: "%Y/%m/%d" #=> format is optional
  named_arg :symbol, type: Symbol
  named_arg :array,  type: Array
  named_arg :aofi,   type: Array, of: Integer #=> casts all elements to Integer
end
```

## Unnamed args

This is something that is often overlooked in command line argument parsing
libraries: the arguments that have no names. The regular input. Obtions does its
best to parse them in and name them just like any other command line data:

``` ruby
require 'obtions'

o = Obitons.parse do
  flag :s
  arg  :first
end
```

Let's say we run that program with the arg string: `-s hello`. Here's what `o`
would look like:

``` ruby
o.s?    #=> true
o.first #=> "hello"
```

Unnamed args will be parsed in in the order they are specified.

## Required args

If the argument is not present, it will just be `nil`. We can, however, make it
a requirement so that Obtions will throw an error if it isn't found:

``` ruby
require 'obtions'

o = Obitons.parse do
  flag :s
  arg  :first, required: true
end
```

Calling this with `-s` will raise an `Obtions::RequiredArgsMissing` error. The
error will have an instance variable called `args` that contains an array of
required arguments that should have been present but were not. Example:

``` ruby
require 'obtions'

begin
  o = Obtions.parse do
    flag      :s
    named_arg :logfile, required: true
    arg       :first, required: true
  end
rescue Obtions::RequiredArgsMissing => e
  e.args.each do |arg|
    puts "#{arg.name} => #{arg.options}"
  end
end
```

Calling the above program with an empty arg string will raise an error and the
following output is produced:

```
logfile => {:required=>true}
first => {:required=>true}
```
