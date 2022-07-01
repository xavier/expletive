# Expletive [![hex.pm](https://img.shields.io/hexpm/v/expletive)](https://hex.pm/packages/expletive)

An obscenity detection and filtering library for Elixir, freely inspired by the [obscenity gem](https://github.com/tjackiw/obscenity).

## Installation

Add Expletive as a dependency to your project `mix.exs`:

```Elixir

def deps do
  [{:expletive, "~> 0.1.0"}]
end

```

## Usage

All Expletive functions expect a configuration to be passed:

```Elixir

config = Expletive.configure(blacklist: ~w[very bad words])

Expletive.profane?("this is bad!", config)
# => true
Expletive.profane?("perfectly safe", config)
# => false

Expletive.profanities("this is bad, so BAD!", config)
# => ["bad", "BAD"]
```

### Sanitization

The library offers a fairly wide variety of profanity replacement strategies which can be defined at configuration time or passed explicitly.

```Elixir
Expletive.sanitize("this is bad, so BAD!", config)
# => "This is $#!@%, so %$@!#!"

Expletive.sanitize("this is bad, so BAD!", config, :stars)
# => "This is ***, so ***!"

Expletive.sanitize("this is bad, so BAD!", config, :vowels)
# => "This is b*d, so B*D!

Expletive.sanitize("this is bad, so BAD!", config, ":poop:")
# => "This is :poop:, so :poop:!

Expletive.sanitize("this is bad, so BAD!", config, {:repeat, "-"})
# => "This is ---, so ---!

Expletive.sanitize("this is bad, so BAD!", config, :keep_first_letter)
# => "This is b**, so B**!

Expletive.sanitize("this is bad, so BAD!", config, {:keep_first_letter, "-"})
# => "This is b--, so B--!

```

### Whitelisting

If you wish to allow some words present in the blacklist, you can add exceptions to a whitelist at configuration time:

```Elixir
config = Expletive.configure(blacklist: ~w[very bad words], whitelist: ~w[words])

Expletive.profane?("words", config)
# => false

```

### Built-in blacklists

The library comes with a couple of word lists ready to use:

```Elixir

config = Expletive.configure(blacklist: Expletive.Blacklist.english)

Expletive.profane?("this is batshit crazy!", config)
# => true

config = Expletive.configure(blacklist: Expletive.Blacklist.international)

Expletive.profanities("ceci n'est pas une pipe", config)
# => ["pipe"]

```

## Known Limitations

### I18n concerns

A couple of replacement strategies (`:vowels` and `:nonconsonants`) are currently limited to the english language.
