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
    POST 	/session 	New Session
    DELETE 	/session/{session id} 	Delete Session
    GET 	/status 	Status
  """

  def open_browser(browser) do
    start_link(browser)
    conn = MintHelper.connect_to_session(browser)
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session(browser)
    SessionAgent.start_link(session_data["value"]["sessionId"])
  end

  def end_session do
    Commands.delete_session
    {:ok, _conn} = Mint.HTTP.close(ConnectionAgent.conn)
  end

  def get_status do
    [:ok, :ok, status, :ok] = Commands.get_status
    status["value"]
  end

  @doc """
    TIMEOUTS
    GET 	/session/{session id}/timeouts 	Get Timeouts
    POST 	/session/{session id}/timeouts 	Set Timeouts
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
    POST 	/session/{session id}/url 	Navigate To
    GET 	/session/{session id}/url 	Get Current URL
    POST 	/session/{session id}/back 	Back
    POST 	/session/{session id}/forward 	Forward
    POST 	/session/{session id}/refresh 	Refresh
    GET 	/session/{session id}/title 	Get Title
  """

  def go_to(url) do
    Commands.set_url(url)
  end

  def get_url do
    [:ok, :ok, url, :ok] = Commands.get_url
    url["value"]
  end

  def back do
    Commands.back
  end

  def forward do
    Commands.forward
  end

  def refresh do
    # need to stop the previous element to keep from a stale element error
    ElementAgent.stop
    Commands.refresh
  end

  def title do
    [:ok, :ok, url, :ok] = Commands.get_title
    url["value"]
  end

  @doc """
    CONTEXTS
    GET 	/session/{session id}/window 	Get Window Handle
    DELETE 	/session/{session id}/window 	Close Window
    POST 	/session/{session id}/window 	Switch To Window
    GET 	/session/{session id}/window/handles 	Get Window Handles
    POST 	/session/{session id}/frame 	Switch To Frame
    POST 	/session/{session id}/frame/parent 	Switch To Parent Frame
    GET 	/session/{session id}/window/rect 	Get Window Rect
    POST 	/session/{session id}/window/rect 	Set Window Rect
    POST 	/session/{session id}/window/maximize 	Maximize Window
    POST 	/session/{session id}/window/minimize 	Minimize Window
    POST 	/session/{session id}/window/fullscreen 	Fullscreen Window
  """

  def get_window_handle do
    [:ok, :ok, handle, :ok] = Commands.get_window_handle
    handle["value"]
  end

  def close_window do
    [:ok, :ok, handle, :ok] = Commands.close_window
    handle["value"]
  end

  def switch_to_window(handle) do
    [:ok, :ok, handle, :ok] = Commands.switch_to_window(handle)
    handle
  end

  def get_window_handles do
    [:ok, :ok, handles, :ok] = Commands.get_window_handles
    handles["value"]
  end

  def new_window do
    [:ok, :ok, handle, :ok] = Commands.new_window
    handle["value"]
  end

  def switch_to_frame do
    [:ok, :ok, handle, :ok] = Commands.switch_to_frame
    handle["value"]
  end

  def switch_to_parent_frame do
    [:ok, :ok, handle, :ok] = Commands.switch_to_parent_frame
    handle["value"]
  end

  def get_window_rect do
    [:ok, :ok, handle, :ok] = Commands.get_window_rect
    handle["value"]
  end

  def set_window_rect(width, height, x, y) do
    Commands.set_window_rect(width, height, x, y)
  end

  def maximize_window do
    Commands.maximize_window
  end

  def minimize_window do
    Commands.minimize_window
  end

  def fullscreen_window do
    Commands.fullscreen_window
  end

  @doc """
    DOCUMENT
    GET 	/session/{session id}/source 	Get Page Source
    POST 	/session/{session id}/execute/sync 	Execute Script
    POST 	/session/{session id}/execute/async 	Execute Async Script
  """

  @spec get_page_source :: String
  def get_page_source do
    [:ok, :ok, text, :ok] = Commands.get_page_source
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
    GET 	/session/{session id}/cookie 	Get All Cookies
    GET 	/session/{session id}/cookie/{name} 	Get Named Cookie
    POST 	/session/{session id}/cookie 	Add Cookie
    DELETE 	/session/{session id}/cookie/{name} 	Delete Cookie
    DELETE 	/session/{session id)/cookie 	Delete All Cookies
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

  def delete_cookie(cookie) do
    Commands.delete_cookie(cookie)
  end

  def delete_all_cookies do
    Commands.delete_all_cookies
  end

  @doc """
    ACTIONS
    POST 	/session/{session id}/actions 	Perform Actions
    DELETE 	/session/{session id}/actions 	Release Actions
  """
  def perform_actions(actions) do
  end

  def release_actions do
  end

  @doc """
    USER PROMPTS
    POST 	/session/{session id}/alert/dismiss 	Dismiss Alert
    POST 	/session/{session id}/alert/accept 	Accept Alert
    GET 	/session/{session id}/alert/text 	Get Alert Text
    POST 	/session/{session id}/alert/text 	Send Alert Text
  """

  def dismiss_alert do
    Commands.dismiss_alert
  end

  def accept_alert do
    Commands.accept_alert
  end

  def get_alert_text do
    [:ok, :ok, text, :ok] = Commands.get_alert_text
    text["value"]
  end

  def send_alert_text(text) do
    Commands.send_alert_text(text)
  end

  @doc """
    SCREEN CAPTURE
    GET 	/session/{session id}/screenshot 	Take Screenshot
    GET 	/session/{session id}/element/{element id}/screenshot 	Take Element Screenshot
  """

  def save_screenshot(file_name) do
    [:ok, :ok, response, :ok] = Commands.take_screenshot
    File.write(file_name, Base.decode64!(response["value"]))
  end

  def save_screenshot_of_element(file_name) do
    [:ok, :ok, response, :ok] = Commands.take_element_screenshot
    File.write(file_name, Base.decode64!(response["value"]))
  end

  @doc """
    PRINT
  """

  def print_page(file_name, range \\ "", total_pages \\ "") do
    [:ok, :ok, response, :ok] = Commands.print_page(range, total_pages)
    File.write(file_name, Base.decode64!(response["value"]))
  end

end
