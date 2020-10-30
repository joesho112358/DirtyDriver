defmodule DirtyDriver.Commands do

  @moduledoc """
    Implements the commands needed to drive the browser
    https://www.w3.org/TR/webdriver2/#endpoints

    Search these sections below:
    SESSIONS
    TIMEOUTS
    NAVIGATION
    CONTEXTS
    ELEMENTS
    DOCUMENT
    COOKIES
    ACTIONS
    USER PROMPTS
    SCREEN CAPTURE
    PRINT
  """

  alias DirtyDriver.MintHelper

  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.ElementAgent

  @doc """
    SESSIONS
  """
  def start_session do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.value_from_response(MintHelper.receive_message(conn, request_ref))
  end

  def delete_session do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "DELETE",
      "/session/#{SessionAgent.session_id()}/window",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_status do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/status",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    TIMEOUTS
  """
  def get_timeouts do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/timeouts",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def set_timeouts do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/timeouts",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    NAVIGATION
  """
  def set_url(url) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/url",
      [{"content-type", "application/json"}],
      "{\"url\": \"#{url}\"}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_url do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/url",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def back do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/back",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def forward do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/forward",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def refresh do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/refresh",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_title do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/title",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    CONTEXTS
  """
  def get_window_handle do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/window",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def close_window do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "DELETE",
      "/session/#{SessionAgent.session_id()}/window",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  #  hmmm need to get window handle
  def switch_to_window(handle) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/window",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_window_handles do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/window/handles",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def new_window do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/window/new",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def switch_to_frame do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/frame",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def switch_to_parent_frame do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/frame/parent",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_window_rect do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/window/rect",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def set_window_rect(width, height, x, y) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/window/rect",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def maximize_window do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/window/maximize",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def minimize_window do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/window/minimize",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def fullscreen_window do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/window/fullscreen",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    ELEMENTS
  """
  def get_active_element do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/active",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def find_element(location, selector) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/element",
      [{"content-type", "application/json"}],
      "{\"using\": \"#{selector}\", \"value\": \"#{location}\"}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def find_elements(location, selector) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/elements",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def find_element_from_element(location, selector) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/element",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def find_elements_from_element(location, selector) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/elements",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def is_element_selected do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/selected",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_element_attribute(name) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/attribute/#{name}",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_element_property(name) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/property/#{name}",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_element_css_value(name) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/css/#{name}",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_element_text do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/text",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_element_tag_name do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/name",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_element_rect do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/rect",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def is_element_enabled do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/enabled",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_computed_role do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/computedrole",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_computed_label do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/computedlabel",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def element_click do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/click",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def element_clear do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/clear",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def element_send_keys(text) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/value",
      [{"content-type", "application/json"}],
      "{\"text\": \"#{text}\"}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    DOCUMENT
  """
  def get_page_source do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/source",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def execute_script(script) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/execute/sync",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def execute_async_script(script) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/execute/async",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    COOKIES
  """
  def get_all_cookies do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/cookie",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_named_cookie(name) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/cookie/#{name}",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def add_cookie(cookie) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/cookie",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def delete_cookie(name) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "DELETE",
      "/session/#{SessionAgent.session_id()}/cookie/#{name}",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def delete_all_cookies do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "DELETE",
      "/session/#{SessionAgent.session_id()}/cookie",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    ACTIONS
  """
  def perform_actions(actions) do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/actions",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def release_actions do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "DELETE",
      "/session/#{SessionAgent.session_id()}/actions",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    USER PROMPTS
  """
  def dismiss_alert do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/alert/dismiss",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def accept_alert do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/alert/accept",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def get_alert_text do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/alert/text",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def send_alert_text do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/alert/text",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    SCREEN CAPTURE
  """
  def take_screenshot do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/screenshot",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  def take_element_screenshot do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "GET",
      "/session/#{SessionAgent.session_id()}/element/#{ElementAgent.element()}/screenshot",
      [],
      ""
    )

    MintHelper.receive_message(conn, request_ref)
  end

  @doc """
    PRINT
  """
  def print_page do
    {:ok, conn, request_ref} = Mint.HTTP.request(
      ConnectionAgent.conn(),
      "POST",
      "/session/#{SessionAgent.session_id()}/print",
      [{"content-type", "application/json"}],
      "{}"
    )

    MintHelper.receive_message(conn, request_ref)
  end

end
