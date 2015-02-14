defmodule ConfigurationTest do
  use ExUnit.Case

  alias Expletive.Configuration, as: Configuration

  test "setting whitelist with a list" do
    config = Configuration.new(whitelist: ["bad", "words"])
    assert Set.to_list(config.whitelist) == ["bad", "words"]
  end

  test "setting whitelist with a string" do
    config = Configuration.new(whitelist: "bad words")
    assert Set.to_list(config.whitelist) == ["bad", "words"]
  end

  test "setting blacklist with a list" do
    config = Configuration.new(blacklist: ["bad", "words"])
    assert Set.to_list(config.blacklist) == ["bad", "words"]
  end

  test "setting blacklist with a string" do
    config = Configuration.new(blacklist: "bad words")
    assert Set.to_list(config.blacklist) == ["bad", "words"]
  end

end
