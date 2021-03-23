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
    on_exit(
      fn ->
        DirtyDriver.TestServer.stop(http_server_pid)
      end
    )

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

  @doc """
    TIMEOUTS
  """

  test "can get timeouts" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert Browser.get_timeouts == %{"implicit" => 0, "pageLoad" => 300000, "script" => 30000}
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can set implicit timeout" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.set_timeouts("{\"implicit\": 123}")
      assert Browser.get_timeouts["implicit"] == 123
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can set pageLoad timeout" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.set_timeouts("{\"pageLoad\": 123}")
      assert Browser.get_timeouts["pageLoad"] == 123
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can set script timeout" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.set_timeouts("{\"script\": 123}")
      assert Browser.get_timeouts["script"] == 123
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  @doc """
    NAVIGATION
  """

  test "can nav to url" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert Commands.get_url == [:ok, :ok, %{"value" => "http://localhost:5555/index.html"}, :ok]
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

  @doc """
    CONTEXTS
  """

  test "can get window handle" do
    try do
      handle = Browser.get_window_handle()
      assert Regex.match?(~r/\d+/, handle)
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can close window" do
    try do
      returned_sessions = Browser.close_window()
      assert returned_sessions == []
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can switch windows" do
    try do
      current_handle = Browser.get_window_handle()
      new_handle = Browser.new_window()["handle"]
      Browser.switch_to_window(new_handle)
      assert new_handle == Browser.get_window_handle()
      Browser.switch_to_window(current_handle)
      assert current_handle == Browser.get_window_handle()
    after
      Browser.close_window()
      [handle] = Browser.get_window_handles()
      Browser.switch_to_window(handle)
      Browser.close_window()
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get handles of all open windows" do
    try do
      current_handle = Browser.get_window_handle()
      new_handle = Browser.new_window()["handle"]
      all_handles = Browser.get_window_handles()
      assert Enum.member?(all_handles, current_handle)
      assert Enum.member?(all_handles, new_handle)
    after
      Browser.close_window()
      [handle] = Browser.get_window_handles()
      Browser.switch_to_window(handle)
      Browser.close_window()
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can open new window" do
    try do
      returned_sessions = Browser.new_window()
      assert Map.keys(returned_sessions) == ["handle", "type"]
    after
      Browser.close_window()
      [handle] = Browser.get_window_handles()
      Browser.switch_to_window(handle)
      Browser.close_window()
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  @doc """
    DOCUMENT
  """

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

  test "can execute a script on the page" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      script = "document.getElementById('piece_o_text').textContent='yolo'"
      Browser.execute_script(script)

      assert ElementInteraction.text("#piece_o_text", "css selector") == "yolo"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can execute a script with arguments on the page" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      script = "document.getElementById('piece_o_text').textContent=arguments[0]"
      Browser.execute_script(script, ["yolo"])

      assert ElementInteraction.text("#piece_o_text", "css selector") == "yolo"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can execute an async script on the page" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      script = "return 1 + 2;"
      returned_value = Browser.execute_async_script(script)

      assert returned_value["error"] == "script timeout"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  @doc """
    COOKIES
  """

  test "can get all cookies when there are none" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      assert Browser.get_all_cookies() == []
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get all cookies when there are some" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.add_cookie("{\"name\":\"logged_in\", \"value\":\"no\"}")
      Browser.add_cookie("{\"name\":\"present\", \"value\":\"yes\"}")
      assert Browser.get_all_cookies() == [
               %{
                 "domain" => "localhost",
                 "httpOnly" => false,
                 "name" => "logged_in",
                 "path" => "/",
                 "sameSite" => "None",
                 "secure" => false,
                 "value" => "no"
               },
               %{
                 "domain" => "localhost",
                 "httpOnly" => false,
                 "name" => "present",
                 "path" => "/",
                 "sameSite" => "None",
                 "secure" => false,
                 "value" => "yes"
               }
             ]
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can get cookies by name" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.add_cookie("{\"name\":\"present\", \"value\":\"yes\"}")
      assert Browser.get_named_cookie("present") == %{
               "domain" => "localhost",
               "httpOnly" => false,
               "name" => "present",
               "path" => "/",
               "sameSite" => "None",
               "secure" => false,
               "value" => "yes"
             }
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "get non-existent cookie by name returns an error" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      response = Browser.get_named_cookie("present")
      assert Enum.member?(Map.keys(response), "error")
      assert Enum.member?(Map.keys(response), "message")
      assert Enum.member?(Map.keys(response), "stacktrace")
      assert response["error"] == "no such cookie"
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  test "can add cookies" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      Browser.add_cookie("{\"name\":\"present\", \"value\":\"yes\"}")
      assert Browser.get_named_cookie("present") == %{
               "domain" => "localhost",
               "httpOnly" => false,
               "name" => "present",
               "path" => "/",
               "sameSite" => "None",
               "secure" => false,
               "value" => "yes"
             }
    after
      Browser.end_session()
      Browser.kill_driver()
    end
  end

  @doc """
    USER PROMPTS
  """

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

  test "can accept alert" do
    try do
      Browser.go_to("http://localhost:5555/index.html")
      ElementInteraction.click("#alert", "css selector")
      Browser.accept_alert()
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

end
