defmodule Expletive.Replacement do
  @moduledoc false

  @star "*"
  @garble ~w[$ @ ! # %]

  # FIXME must be parameterized for I18N
  @vowels ~r/[aeiou]/i

  # FIXME must be parameterized for I18N
  @nonconsonants ~r/[^bcdfghjklmnpqrstvwxyz]/i

  def replace(word, :default), do: replace(word, :garbled)

  def replace(_, :garbled) do
    @garble |> Enum.shuffle() |> Enum.join()
  end

  def replace(word, :stars) do
    String.duplicate(@star, String.length(word))
  end

  def replace(word, :vowels) do
    word |> String.replace(@vowels, @star)
  end

  def replace(word, :nonconsonants) do
    word |> String.replace(@nonconsonants, @star)
  end

  def replace(word, :keep_first_letter) do
    replace(word, {:keep_first_letter, @star})
  end

  def replace(word, {:keep_first_letter, custom}) do
    prefix = String.first(word)
    suffix = String.duplicate(custom, String.length(word) - 1)
    prefix <> suffix
  end

  def replace(word, {:repeat, custom}) do
    String.duplicate(custom, String.length(word))
  end

  def replace(_word, custom) when is_binary(custom) do
    custom
  end
end
