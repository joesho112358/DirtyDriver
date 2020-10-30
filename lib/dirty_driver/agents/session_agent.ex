defmodule DirtyDriver.SessionAgent do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def session_id do
    Agent.get(__MODULE__, & &1)
  end

end
