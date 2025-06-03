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

  test "setting match_substrings with true" do
    config = Configuration.new(blacklist: ["bad", "words"], match_substrings: true)
    assert config.match_substrings == true
    assert config.regex
  end

  test "setting match_substrings with false" do
    config = Configuration.new(blacklist: ["bad", "words"], match_substrings: false)
    assert config.match_substrings == false
    assert config.regex
  end

  test "default match_substrings value" do
    config = Configuration.new(blacklist: ["bad", "words"])
    assert config.match_substrings == false
  end

  test "update match_substrings configuration" do
    original = Configuration.new(blacklist: "bad words", match_substrings: true)
    updated = Configuration.update(original, match_substrings: false)
    assert updated.match_substrings == false
    assert updated.regex != original.regex
  end
end
