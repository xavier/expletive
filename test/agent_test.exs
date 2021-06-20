defmodule AgentTest do
  use ExUnit.Case

  setup do
    {:ok, english} =
      Expletive.Agent.start_link(
        blacklist: ~w[bad words],
        whitelist: ~w[words],
        replacement: "[redacted]"
      )

    {:ok, french} =
      Expletive.Agent.start_link(
        blacklist: ~w[gros mots],
        whitelist: ~w[mots],
        replacement: :stars
      )

    {:ok, english: english, french: french}
  end

  test "profane?", %{english: english, french: french} do
    assert Expletive.Agent.profane?("bad", english)
    assert !Expletive.Agent.profane?("safe", english)
    assert !Expletive.Agent.profane?("gros", english)

    assert Expletive.Agent.profane?("gros", french)
    assert !Expletive.Agent.profane?("mots", french)
    assert !Expletive.Agent.profane?("bad", french)
  end

  test "profanities?", %{english: english, french: french} do
    string = "bad words, gros mots"
    assert ["bad"] == Expletive.Agent.profanities(string, english)
    assert ["gros"] == Expletive.Agent.profanities(string, french)
  end

  test "sanitize", %{english: english, french: french} do
    assert "so [redacted]!" == Expletive.Agent.sanitize("so BAD!", english)
    assert "**** mots!" == Expletive.Agent.sanitize("GROS mots!", french)
  end

  test "configure", %{english: english, french: french} do
    Expletive.Agent.configure(french, whitelist: [])
    Expletive.Agent.configure(english, blacklist: ["other"])
    assert Expletive.Agent.profane?("mots", french)
    assert Expletive.Agent.profane?("other", english)
  end
end
