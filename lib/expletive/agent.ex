defmodule Expletive.Agent do

  @moduledoc false

  #
  # This is work in progress and not yet part of the public API
  # Use at your own risk
  #

  def start_link(options) do
    Agent.start_link(fn -> Expletive.configure(options) end)
  end

  @doc ""
  def profane?(string, agent) do
    Agent.get(agent, &Expletive.profane?(string, &1))
  end

  @doc ""
  def profanities(string, agent) do
    Agent.get(agent, &Expletive.profanities(string, &1))
  end

  @doc ""
  def sanitize(string, agent) do
    Agent.get(agent, &Expletive.sanitize(string, &1))
  end
end