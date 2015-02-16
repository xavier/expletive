defmodule Expletive.Configuration do

  @moduledoc false

  defstruct whitelist: [],
            blacklist: [],
            replacement: :default,
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

  defp compile(config) do
    %{config | regex: compile_regex(config)}
  end

  defp word_list(words) when is_binary(words), do: String.split(words)
  defp word_list(words) when is_list(words), do: words

  defp compile_regex(config) do
    config
    |> collect_words_to_match
    |> build_pattern
    |> Regex.compile!("iu")
  end

  def collect_words_to_match(config) do
    Enum.filter(config.blacklist, fn word -> !(word in config.whitelist) end)
  end

  def build_pattern([]), do: "$." # will never match
  def build_pattern(words) do
    words
    |> Enum.map(&Regex.escape/1)
    |> Enum.join("|")
    |> wrap_string("\\b(?:", ")\\b")
  end

  def wrap_string(string, prefix, suffix), do: "#{prefix}#{string}#{suffix}"

end