Code.require_file "server.exs", __DIR__

defmodule DirtyDriverTest do
  use ExUnit.Case, async: false

  alias DirtyDriver.Browser
  alias DirtyDriver.MintHelper
  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.Commands

  test "browser is running" do
    Browser.start_link("firefox")
    # can't have the tests firing up before the geckodriver starts
    Process.sleep(1000)

    conn = MintHelper.connect_to_session()
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session()
    SessionAgent.start_link(session_data["value"]["sessionId"])
    Process.sleep(1000)
    assert Commands.get_status == [:ok, :ok, %{"value" => %{"message" => "Session already started", "ready" => false}}, :ok]
  after
    Browser.end_session()
    Browser.kill_driver()
  end

  test "can get browser status" do
    Browser.start_link("firefox")
    # can't have the tests firing up before the geckodriver starts
    Process.sleep(1000)

    conn = MintHelper.connect_to_session()
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session()
    SessionAgent.start_link(session_data["value"]["sessionId"])
    assert Browser.get_status() == %{"message" => "Session already started", "ready" => false}
  after
    Browser.end_session()
    Browser.kill_driver()
  end

  test "can open chrome" do
    Browser.open_browser("chrome")
    status = Browser.get_status()
    assert status["message"] == "ChromeDriver ready for new sessions."
    assert status["ready"] == true
  after
    Browser.end_session()
    Browser.kill_driver()
  end

  test "can open firefox" do
    Browser.open_browser("firefox")
    status = Browser.get_status()
    assert status["message"] == "Session already started"
    assert status["ready"] == false
  after
    Browser.end_session()
    Browser.kill_driver()
  end

end
