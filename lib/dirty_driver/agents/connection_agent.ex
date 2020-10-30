defmodule DirtyDriver.ConnectionAgent do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def conn do
    Agent.get(__MODULE__, & &1)
  end

end
