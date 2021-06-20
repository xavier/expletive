defmodule Expletive do
  @moduledoc """

  A profanity detection and sanitization library.

  """

  alias Expletive.Configuration, as: Configuration
  alias Expletive.Replacement, as: Replacement

  @type replacement ::
          :default
          | :garbled
          | :stars
          | :vowels
          | :nonconsonants
          | String.t()
          | {:repeat, String.t()}
          | :keep_first_letter
          | {:keep_first_letter, String.t()}

  @doc """
  Returns a configuration to pass to other functions.

  * `:blacklist` - A list of words which are considered profane (if a string is given, it will be split on whitespace to create the world list)
  * `:whitelist` - A list of words which are allowed even if they're also present in the blacklist (if a string is given, it will be split on whitespace to create the world list)
  * `:replacement` - A replacement strategy:
      * `:garbled` - Replace by a random permutation of `$@!#%` (default)
      * `:stars` - Replace all characters by `*`
      * `:vowels` - Replace all vowels of the offending word by `*`
      * `:nonconsonants` - Replace all non-consonants of the offending word by `*`
      * `string` - Replace the occurence by the given string
      * `{:repeat, string}` - Replace all characters by the given string
      * `:keep_first_letter` - Replace all characters but the first one by `*`
      * `{:keep_first_letter, string}` - Replace all characters but the first one by the given string
  """
  @spec configure(list) :: Configuration.t()
  def configure(options) do
    Configuration.new(options)
  end

  @doc """
  Updates the configuration. Accepts the same options as `configure/1`
  """
  @spec configure(Configuration.t(), list) :: Configuration.t()
  def configure(config, options) do
    Configuration.update(config, options)
  end

  @doc """
  Returns `true` if the given string contains a word considered profane by the given configuration
  """
  @spec profane?(String.t(), Configuration.t()) :: boolean
  def profane?(string, config) do
    config.regex |> Regex.match?(string)
  end

  @doc """
  Returns a list of profanities found in the given string.  All occurences are returned, duplicates may thus occur
  """
  @spec profanities(String.t(), Configuration.t()) :: [String.t()]
  def profanities(string, config) do
    config.regex
    |> Regex.scan(string)
    |> Enum.map(fn [match] -> match end)
  end

  @doc """
  Replace all profanities by a placeholder as defined by the `replacement` option of the current configuration
  """
  @spec sanitize(String.t(), Configuration.t()) :: String.t()
  def sanitize(string, config) do
    config.regex
    |> Regex.replace(string, fn word -> Replacement.replace(word, config.replacement) end)
  end

  @doc """
  Replace all profanities by a placeholder as defined by the given `replacement` strategy
  """
  @spec sanitize(String.t(), Configuration.t(), replacement) :: String.t()
  def sanitize(string, config, replacement) do
    sanitize(string, %{config | replacement: replacement})
  end
end
