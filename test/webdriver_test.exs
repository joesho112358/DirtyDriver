Code.require_file "server.exs", __DIR__

defmodule DirtyDriverTest do
  use ExUnit.Case, async: false

  alias DirtyDriver.Browser
  alias DirtyDriver.MintHelper
  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.Commands

  setup do
    Browser.start_link("firefox")
    # can't have the tests firing up before the geckodriver starts
    Process.sleep(1000)

    conn = MintHelper.connect_to_session()
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session()
    SessionAgent.start_link(session_data["value"]["sessionId"])

    {:ok, %{}}
  end

  test "browser is running" do
    Process.sleep(1000)
    assert Commands.get_status == [:ok, :ok, %{"value" => %{"message" => "Session already started", "ready" => false}}, :ok]
  after
    Browser.end_session()
    Browser.kill_driver()
  end

  test "can get browser status" do
    assert Browser.get_status() == %{"message" => "Session already started", "ready" => false}
  after
    Browser.end_session()
    Browser.kill_driver()
  end

end
