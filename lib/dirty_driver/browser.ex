defmodule DirtyDriver.Browser do
  use Task

  alias DirtyDriver.MintHelper
  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.Commands
  alias DirtyDriver.ElementAgent

  def start_link(browser) do
    Task.start_link(__MODULE__, :start, [browser])
  end

  def kill_driver do
    {pid, _} = System.cmd("pidof", ["geckodriver"])
    if pid, do: System.cmd("kill", ["-9", String.trim(pid)])
    {pid, _} = System.cmd("pidof", ["chromedriver"])
    if pid, do: System.cmd("kill", ["-9", String.trim(pid)])
  end

  def start(browser) do
    try do
      case browser do
        "firefox" -> System.cmd("geckodriver", [])
        "chrome" -> System.cmd("chromedriver", [])
        _ -> IO.puts("Something went wrong")
      end
    after
      IO.puts "Running"
    end
  end

  @doc """
    SESSIONS
  """

  def open_browser(browser) do
    start_link(browser)
    conn = MintHelper.connect_to_session(browser)
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session(browser)
    SessionAgent.start_link(session_data["value"]["sessionId"])
  end

  def end_session do
    Commands.delete_session()
    {:ok, _conn} = Mint.HTTP.close(ConnectionAgent.conn())
  end

  def get_status do
    [:ok, :ok, status, :ok] = Commands.get_status()
    status["value"]
  end

  @doc """
    TIMEOUTS
  """

  def get_timeouts do
    [:ok, :ok, timeouts, :ok] = Commands.get_timeouts
    timeouts["value"]
  end

  def set_timeouts(timeout) do
    Commands.set_timeouts(timeout)
  end

  @spec set_implicit_timeout(Integer) :: [any]
  def set_implicit_timeout(timeout) do
    Commands.set_timeouts("{\"implicit\": #{timeout}}")
  end

  @spec set_pageLoad_timeout(Integer) :: [any]
  def set_pageLoad_timeout(timeout) do
    Commands.set_timeouts("{\"pageLoad\": #{timeout}}")
  end

  @spec set_script_timeout(Integer) :: [any]
  def set_script_timeout(timeout) do
    Commands.set_timeouts("{\"script\": #{timeout}}")
  end

  @doc """
    NAVIGATION
  """

  def go_to(url) do
    Commands.set_url(url)
  end

  def get_url() do
    [:ok, :ok, url, :ok] = Commands.get_url()
    url["value"]
  end

  def back() do
    Commands.back()
  end

  def forward() do
    Commands.forward()
  end

  def refresh() do
    # need to stop the previous element to keep from a stale element error
    ElementAgent.stop()
    Commands.refresh()
  end

  def title() do
    [:ok, :ok, url, :ok] = Commands.get_title()
    url["value"]
  end

  @doc """
    CONTEXTS
  """

  def get_window_handle() do
    [:ok, :ok, handle, :ok] = Commands.get_window_handle
    handle["value"]
  end

  def close_window() do
    [:ok, :ok, handle, :ok] = Commands.close_window
    handle["value"]
  end

  def switch_to_window(handle) do
    Commands.switch_to_window(handle)
  end

  def get_window_handles() do
    [:ok, :ok, handles, :ok] = Commands.get_window_handles
    handles["value"]
  end

  def new_window() do
    Commands.new_window
  end

  @doc """
    DOCUMENT
  """

  @spec get_page_source :: String
  def get_page_source do
    [:ok, :ok, text, :ok] = Commands.get_page_source()
    text["value"]
  end

  def execute_script(script, arguments \\ []) do
    [:ok, :ok, result, :ok] = Commands.execute_script(script, arguments)
    result["value"]
  end

  def execute_async_script(script, arguments \\ []) do
    [:ok, :ok, result, :ok] = Commands.execute_async_script(script, arguments)
    result["value"]
  end

  @doc """
    COOKIES
  """

  def get_all_cookies do
    [:ok, :ok, result, :ok] = Commands.get_all_cookies
    result["value"]
  end

  def get_named_cookie(name) do
    [:ok, :ok, result, :ok] = Commands.get_named_cookie(name)
    result["value"]
  end

  def add_cookie(cookie) do
    Commands.add_cookie(cookie)
  end

  @doc """
    USER PROMPTS
  """

  def dismiss_alert do
    Commands.dismiss_alert()
  end

  def accept_alert do
    Commands.accept_alert()
  end

  def get_alert_text do
    [:ok, :ok, text, :ok] = Commands.get_alert_text()
    text["value"]
  end

  def send_alert_text(text) do
    Commands.send_alert_text(text)
  end

  @doc """
    SCREEN CAPTURE
  """


end
