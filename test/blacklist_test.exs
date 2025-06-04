defmodule BlacklistTest do
  use ExUnit.Case

  alias Expletive.Blacklist, as: Blacklist

  @english_blacklist_config Expletive.configure(blacklist: Expletive.Blacklist.english())
  @international_blacklist_config Expletive.configure(
                                    blacklist: Expletive.Blacklist.international()
                                  )

  test "english blacklist" do
    assert Enum.member?(Blacklist.english(), "wrapping the weasel")
  end

  test "international blacklist" do
    assert Enum.member?(Blacklist.international(), "shitty")
    assert Enum.member?(Blacklist.international(), "zob")
  end

  test "should return true if word is in the english blacklist" do
    assert Expletive.profane?("shit", @english_blacklist_config) === true
  end

  test "should return false if word is not in the english blacklist" do
    assert Expletive.profane?("hello", @english_blacklist_config) === false
  end

  test "should return true if word is in the international blacklist" do
    assert Expletive.profane?("arsch", @international_blacklist_config) === true
  end

  test "should return false if word is not in the international blacklist" do
    assert Expletive.profane?("hello", @international_blacklist_config) === false
  end
end
