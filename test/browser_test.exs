Code.require_file "server.exs", __DIR__

defmodule DirtyDriverBrowserTest do
  use ExUnit.Case, async: false

  alias DirtyDriver.Browser
  alias DirtyDriver.ElementInteraction
  alias DirtyDriver.MintHelper
  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.Commands

  setup_all do
    http_server_pid = DirtyDriver.TestServer.start

    Process.sleep(500)
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

  test "can nav to url" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert Commands.get_url == [:ok, :ok, %{"value" => "http://localhost:5555/index.html"}, :ok]
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can go back in the browser" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.go_to("http://localhost:5555/other_page.html")
      Browser.back
      assert Browser.get_url == "http://localhost:5555/index.html"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get url" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert Browser.get_url == "http://localhost:5555/index.html"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can go forward in the browser" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.go_to("http://localhost:5555/other_page.html")
      Browser.back
      Browser.forward
      assert Browser.get_url == "http://localhost:5555/other_page.html"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can refresh the browser" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      ElementInteraction.set_text("#text_field", "css selector", "hello")
      Browser.refresh
      assert ElementInteraction.value("#text_field", "css selector") == "Text"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get browser title" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert Browser.title() == "Index"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get window handle" do
    try do
      handle = Browser.get_window_handle()
      assert Regex.match?(~r/\d+/, handle)
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get alert text" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      ElementInteraction.click("#alert", "css selector")
      assert Browser.get_alert_text() == "alert!"
      Browser.dismiss_alert()
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can dismiss alert" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      ElementInteraction.click("#alert", "css selector")
      Browser.dismiss_alert()
      error_message = Browser.get_alert_text()["error"]
      assert error_message != nil
      assert error_message != ""
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can send text to prompt" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      ElementInteraction.click("#prompt", "css selector").stop()
      Browser.send_alert_text("test text")
      Browser.accept_alert()
      assert ElementInteraction.text("#prompt_text", "css selector") == "test text"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get page source code" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      contents = "<html><head>\n        <title>Index</title>\n    </head>\n    <body>"
      assert String.contains?(Browser.get_page_source(), contents)
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

end
