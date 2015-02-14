defmodule Expletive.Blacklist do

  strip_quotes = fn (word) -> String.replace(word, ~r/^"\s*|\s*"$/, "") end

  data_dir = Path.join([__DIR__, "..", "..", "data", "*.txt"])

  for file <- Path.wildcard(data_dir) do

    fun_name = Path.basename(file, ".txt") |> String.to_atom

    words = File.read!(file)
            |> String.split("\n")
            |> Enum.map(strip_quotes)

    @doc "Returns #{fun_name} words to blacklist"
    def unquote(fun_name)(), do: unquote(words)

  end

end

