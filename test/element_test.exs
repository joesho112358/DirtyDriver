Code.require_file "server.exs", __DIR__

defmodule DirtyDriverElementTest do
  use ExUnit.Case, async: false

  alias DirtyDriver.Browser
  alias DirtyDriver.MintHelper
  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.Commands
  alias DirtyDriver.ElementInteraction

  setup_all do
    http_server_pid = DirtyDriver.TestServer.start

    on_exit(fn ->
      DirtyDriver.TestServer.stop(http_server_pid)
    end)

    :ok
  end

  setup do
    Browser.start_link("firefox")
    # can't have the tests firing up before the geckodriver starts
    Process.sleep(1000)

    conn = MintHelper.connect_to_session()
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session()
    SessionAgent.start_link(session_data["value"]["sessionId"])

    :ok
  end

  test "can get element's tag name" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert ElementInteraction.tag_name("#piece_o_text", "css selector") == "h1"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get text field element's value" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert ElementInteraction.value("#text_field", "css selector") == "Text"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get text element's text" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert ElementInteraction.text("#piece_o_text", "css selector") == "Index"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get text element's text after the getting element" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      ElementInteraction.element("#piece_o_text", "css selector")
      assert ElementInteraction.text() == "Index"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get invisibile element's as status as not visible" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      ElementInteraction.element("#invisible", "css selector")
      assert ElementInteraction.visible?() == false
      ElementInteraction.element("#invisible2", "css selector")
      assert ElementInteraction.visible?() == false
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

end
