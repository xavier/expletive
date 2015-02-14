defmodule Expletive.Configuration do

  @moduledoc false

  defstruct whitelist: HashSet.new, blacklist: HashSet.new, replacement: :default

  def new(options) do
    %__MODULE__{
      whitelist: Keyword.get(options, :whitelist, []) |> word_set,
      blacklist: Keyword.get(options, :blacklist, []) |> word_set,
      replacement: Keyword.get(options, :replacement, :default)
    }
  end

  defp word_set(words) when is_binary(words), do: String.split(words) |> word_set
  defp word_set(words) when is_list(words), do: words |> Enum.into(HashSet.new)

end