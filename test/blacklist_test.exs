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

  test "should return true if word contains profanity from english blacklist" do
    # "hello" contains "hell" which is in the blacklist, so with substring matching it's now detected
    assert Expletive.profane?("hello", @english_blacklist_config) === true
  end

  test "should return true if word is in the international blacklist" do
    assert Expletive.profane?("arsch", @international_blacklist_config) === true
  end

  test "should return true if word contains profanity from international blacklist" do
    # "hello" contains "hell" which is in the blacklist, so with substring matching it's now detected
    assert Expletive.profane?("hello", @international_blacklist_config) === true
  end

  test "substring matching for english blacklist" do
    assert Expletive.profane?("shittyword", @english_blacklist_config) === true
    assert Expletive.profane?("wordshitty", @english_blacklist_config) === true
    assert Expletive.profane?("safe", @english_blacklist_config) === false
  end
end
