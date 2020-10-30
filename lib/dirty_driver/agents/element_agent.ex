defmodule DirtyDriver.ElementAgent do
  use Agent

  @doc """
    Parses expected element map
  """
  defp parse_map(map) do
    List.first(Map.values(elem(map, 0)["value"]))
  end

  @doc """
    Expects a map like
    %{
      "value" => %{
        "element-6066-11e4-a52e-4f735466cecf" => "c50acacd-a458-44d1-a868-122769d2c2fd"
      }
    }
  """
  def start_link(initial_value) do
    Agent.start_link(fn -> parse_map(initial_value) end, name: __MODULE__)
  end

  def element do
    Agent.get(__MODULE__, & &1)
  end

  def set_element(element) do
    Agent.update(__MODULE__, fn _ -> parse_map(element) end)
  end

end
