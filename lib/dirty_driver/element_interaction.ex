defmodule DirtyDriver.ElementInteraction do
  alias DirtyDriver.Commands
  alias DirtyDriver.ElementAgent
  alias DirtyDriver.MintHelper

  def element(location, strategy) do
    element = Commands.find_element(location, strategy)
    ElementAgent.start_link(List.pop_at(element, 2))
  end

  def set_text(text), do: Commands.element_send_keys(text)
  def set_text(location, strategy, text) do
    element(location, strategy)
    set_text(text)
  end

  def tag_name(), do: MintHelper.value_from_response(Commands.get_element_tag_name())["value"]
  def tag_name(location, strategy) do
    element(location, strategy)
    tag_name()
  end

  def value(), do: MintHelper.value_from_response(Commands.get_element_property("value"))["value"]
  def value(location, strategy) do
    element(location, strategy)
    value()
  end

  def text(location, strategy) do
    element(location, strategy)
    text()
  end

  def text do
    MintHelper.value_from_response(Commands.get_element_text())["value"]
  end

  def click, do: Commands.element_click()
  def click(location, strategy) do
    element(location, strategy)
    click()
  end

  def visible?(location, strategy) do
    element(location, strategy)
    visible?()
  end

  def visible? do
    response = MintHelper.value_from_response(Commands.get_element_css_value("display"))["value"]

    response != "none"
  end

end
