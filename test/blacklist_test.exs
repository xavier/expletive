defmodule BlacklistTest do
  use ExUnit.Case

  alias Expletive.Blacklist, as: Blacklist

  test "english blacklist" do
    assert Enum.member?(Blacklist.english, "wrapping the weasel")
  end

  test "international blacklist" do
    assert Enum.member?(Blacklist.international, "shitty")
    assert Enum.member?(Blacklist.international, "zob")
  end

end