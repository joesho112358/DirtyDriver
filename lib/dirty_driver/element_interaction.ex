defmodule DirtyDriver.ElementInteraction do
  alias DirtyDriver.Commands
  alias DirtyDriver.ElementAgent
  alias DirtyDriver.MintHelper

  def stop, do: ElementAgent.stop
  def stop(name), do: ElementAgent.stop(name)

  def element(location, strategy) do
    response = Commands.find_element(location, strategy)
    {element, _} = List.pop_at(response, 2)
    ElementAgent.start_link(element)
    __MODULE__
  end

  def elements(location, strategy) do
    response = Commands.find_elements(location, strategy)
    {elements, _} = List.pop_at(response, 2)

    get_elements_agents elements["value"]
  end

  defp get_elements_agents(elements), do: get_elements_agents(elements, 0, [])
  defp get_elements_agents([], _, return_names) do
    Enum.map(Enum.reverse(return_names), fn x -> ElementAgent.element(x) end)
  end
  defp get_elements_agents([element | elements], counter, return_names) do
    atomized = counter |> Integer.to_string |> String.to_atom
    mapped_element = %{
      "value" => element
    }
    ElementAgent.start_link(mapped_element, atomized)
    return_names = [atomized | return_names]
    get_elements_agents(elements, counter + 1, return_names)
  end

  def set_text(text) do
    Commands.element_send_keys(text)
    __MODULE__
  end

  def set_text(location, strategy, text) do
    element(location, strategy)
    set_text(text)
    __MODULE__
  end

  def tag_name, do: MintHelper.value_from_response(Commands.get_element_tag_name)["value"]
  def tag_name(location, strategy) do
    element(location, strategy)
    tag_name
  end

  def value, do: MintHelper.value_from_response(Commands.get_element_property("value"))["value"]
  def value(location, strategy) do
    element(location, strategy)
    value
  end

  def text(location, strategy) do
    element(location, strategy)
    text
  end

  def text do
    MintHelper.value_from_response(Commands.get_element_text)["value"]
  end

  def text(name) do
    MintHelper.value_from_response(Commands.get_element_text(name))["value"]
  end

  def click do
    Commands.element_click
    __MODULE__
  end

  def click(location, strategy) do
    element(location, strategy)
    click
    __MODULE__
  end

  def visible?(location, strategy) do
    element(location, strategy)
    visible?
  end

  def visible? do
    response = MintHelper.value_from_response(Commands.get_element_css_value("display"))

    response["value"] != "none"
  end

end
