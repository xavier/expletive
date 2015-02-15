defmodule ConfigurationTest do
  use ExUnit.Case

  alias Expletive.Configuration, as: Configuration

  test "setting whitelist with a list" do
    config = Configuration.new(whitelist: ["bad", "words"])
    assert config.whitelist == ["bad", "words"]
    assert config.regex
  end

  test "setting whitelist with a string" do
    config = Configuration.new(whitelist: "bad words")
    assert config.whitelist == ["bad", "words"]
    assert config.regex
  end

  test "setting blacklist with a list" do
    config = Configuration.new(blacklist: ["bad", "words"])
    assert config.blacklist == ["bad", "words"]
    assert config.regex
  end

  test "setting blacklist with a string" do
    config = Configuration.new(blacklist: "bad words")
    assert config.blacklist == ["bad", "words"]
    assert config.regex
  end

  test "update configuration" do
    original = Configuration.new(blacklist: "bad words")
    updated = Configuration.update(original, blacklist: "other words", replacement: :stars)
    assert updated.regex != original.regex
    assert updated.replacement != original.replacement
  end

end
