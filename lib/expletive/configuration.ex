defmodule Expletive.Configuration do
  @moduledoc false

  defstruct whitelist: [],
            blacklist: [],
            replacement: :default,
            match_substrings: false,
            regex: nil

  def new(options) do
    %__MODULE__{} |> update(options)
  end

  def update(config, options) do
    config |> update_config(options) |> compile
  end

  defp update_config(config, options) do
    Enum.reduce(options, config, fn {key, value}, cfg -> update_config(cfg, key, value) end)
  end

  defp update_config(config, :whitelist, value) do
    %{config | whitelist: word_list(value)}
  end

  defp update_config(config, :blacklist, value) do
    %{config | blacklist: word_list(value)}
  end

  defp update_config(config, :replacement, value) do
    %{config | replacement: value}
  end

  defp update_config(config, :match_substrings, value) do
    %{config | match_substrings: value}
  end

  defp compile(config) do
    %{config | regex: compile_regex(config)}
  end

  defp word_list(words) when is_binary(words), do: String.split(words)
  defp word_list(words) when is_list(words), do: words

  defp compile_regex(config) do
    config
    |> collect_words_to_match
    |> build_pattern(config.match_substrings)
    |> Regex.compile!("iu")
  end

  def collect_words_to_match(config) do
    Enum.filter(config.blacklist, fn word -> !(word in config.whitelist) end)
  end

  # will never match
  def build_pattern([], _match_substrings), do: "$."

  def build_pattern(words, match_substrings) do
    escaped_words = Enum.map(words, &Regex.escape/1)

    pattern =
      if match_substrings do
        escaped_words
        |> Enum.join("|")
      else
        escaped_words
        |> Enum.map(fn word -> "\\b#{word}\\b" end)
        |> Enum.join("|")
      end

    wrap_string(pattern, "(?:", ")")
  end

  def wrap_string(string, prefix, suffix), do: "#{prefix}#{string}#{suffix}"
end
