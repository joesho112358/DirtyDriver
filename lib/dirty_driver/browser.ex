defmodule DirtyDriver.Browser do
  use Task

  alias DirtyDriver.MintHelper
  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.Commands

  def start_link(browser) do
    Task.start_link(__MODULE__, :start, [browser])
  end

  def start(browser) do
    try do
      if browser == "firefox" do
        System.cmd("geckodriver", [])
      end
    after
      IO.puts "Running"
    end
  end

  def end_session do
    Commands.delete_session()
    {:ok, _conn} = Mint.HTTP.close(ConnectionAgent.conn())
  end

  def kill_driver do
    {pid, _} = System.cmd("pidof", ["geckodriver"])
    System.cmd("kill", ["-9", String.trim(pid)])
  end

  def open_browser(browser) do
    start_link(browser)
    conn = MintHelper.connect_to_session()
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session()
    SessionAgent.start_link(session_data["value"]["sessionId"])
  end

  def go_to(url) do
    Commands.set_url(url)
  end

end
