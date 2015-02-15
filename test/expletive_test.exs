defmodule ExpletiveTest do
  use ExUnit.Case

  setup_all do
    context = %{config: Expletive.configure(blacklist: ~w[very bad words], whitelist: ~w[words])}
    {:ok, context}
  end

  test "single word in blacklist", %{config: config} do
    assert Expletive.profane?("bad", config)
    assert Expletive.profane?("BAD", config)
    assert Expletive.profane?("BaD", config)
    assert !Expletive.profane?("safe", config)
  end

  test "single word in whitelist", %{config: config} do
    assert !Expletive.profane?("words", config)
    assert !Expletive.profane?("WORDS", config)
    assert !Expletive.profane?("WoRdS", config)
  end

  test "presence of non-word characters around the profanity", %{config: config} do
    assert Expletive.profane?("#bad!", config)
    config = Expletive.configure(config, blacklist: ["bad-ass"|config.blacklist])
    assert Expletive.profane?("#bad-ass!", config)
  end

  test "words in a string", %{config: config} do
    assert Expletive.profane?("some bad words", config)
    assert !Expletive.profane?("good words", config)
  end

  test "bad words with whitespace in a string" do
    config = Expletive.configure(blacklist: ["bad word"])
    assert Expletive.profane?("a bad word in a string", config)
    assert Expletive.profane?("a BaD WoRd in a string", config)
  end

  test "find expletives in a string", %{config: config} do
    assert ["very", "bad"] == Expletive.profanities("very bad words", config)
    assert ["very", "bad", "BAD"] == Expletive.profanities("very bad words are BAD", config)
    assert [] == Expletive.profanities("none to be found", config)
  end

  test "replace expletives with garbled text by default", %{config: config} do
    assert :default = config.replacement
    expected = ~r/there are [$@!#%]{5}, [$@!#%]{5} [$@!#%]{5} words/
    assert Expletive.sanitize("there are bad, VERY BAD words", config) =~ expected
  end

  test "leaves input untouched when no profanities are found", %{config: config} do
    assert "none to be found" == Expletive.sanitize("none to be found", config)
  end

  test "replace expletives with stars", %{config: config} do
    config = %{config | replacement: :stars}
    assert "there are ***, **** *** words" == Expletive.sanitize("there are bad, VERY BAD words", config)
  end

  test "replace expletives vowels with stars", %{config: config} do
    config = %{config | replacement: :vowels}
    assert "there are b*d, V*RY B*D words" == Expletive.sanitize("there are bad, VERY BAD words", config)
  end

  test "replace expletives non-consonants with stars", %{config: config} do
    config = Expletive.configure(config, replacement: :nonconsonants, blacklist: ["b444d"|config.blacklist])
    assert "there are b*d, V*RY B***D words" == Expletive.sanitize("there are bad, VERY B444D words", config)
  end

  test "replace expletives with garbled text", %{config: config} do
    config = %{config | replacement: :garbled}
    expected = ~r/there are [$@!#%]{5}, [$@!#%]{5} [$@!#%]{5} words/
    assert Expletive.sanitize("there are bad, VERY BAD words", config) =~ expected
  end

  test "replace expletives with a custom string", %{config: config} do
    config = %{config | replacement: "💩"}
    assert "there are 💩, 💩 💩 words" == Expletive.sanitize("there are bad, VERY BAD words", config)
  end

  test "replace expletives with a repeated custom string", %{config: config} do
    config = %{config | replacement: {:repeat, "-"}}
    assert "there are ---, ---- --- words" == Expletive.sanitize("there are bad, VERY BAD words", config)
  end

  test "replace expletives with stars, except the first letter", %{config: config} do
    config = %{config | replacement: :keep_first_letter}
    assert "there are b**, V*** B** words" == Expletive.sanitize("there are bad, VERY BAD words", config)
  end

  test "replace expletives with the given character, except the first letter", %{config: config} do
    config = %{config | replacement: {:keep_first_letter, "-"}}
    assert "there are b--, V--- B-- words" == Expletive.sanitize("there are bad, VERY BAD words", config)
  end

  test "replace expletives with a strategy overriding the current configuration", %{config: config} do
    assert "there are ---, ---- --- words" == Expletive.sanitize("there are bad, VERY BAD words", config, {:repeat, "-"})
  end
end
