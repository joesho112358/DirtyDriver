Code.require_file "server.exs", __DIR__

defmodule DirtyDriverURLTest do
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

  test "can nav to url" do
    http_server_pid = DirtyDriver.TestServer.start

    try do
      DirtyDriver.Browser.go_to("http://localhost:5555/index.html")
      assert Commands.get_url == [:ok, :ok, %{"value" => "http://localhost:5555/index.html"}, :ok]
    after
      DirtyDriver.TestServer.stop(http_server_pid)
      Browser.end_session()
      Browser.kill_driver()
    end
  end

end
