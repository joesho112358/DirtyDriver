defmodule DirtyDriver.ElementAgent do
  use Agent

  """
    Parses expected element map
  """
  defp parse_map(map) do
    List.first(Map.values(map["value"]))
  end

  @doc """
    Expects a map like
    %{
      "value" => %{
        "element-6066-11e4-a52e-4f735466cecf" => "c50acacd-a458-44d1-a868-122769d2c2fd"
      }
    }
  """
  def start_link(initial_value, name \\ __MODULE__) do
    Agent.start_link(fn -> parse_map(initial_value) end, name: name)
  end

  def element(name \\ __MODULE__) do
    Agent.get(name, & &1)
  end

  def set_element(element, name \\ __MODULE__) do
    Agent.update(name, fn _ -> parse_map(element) end)
  end

end
