defmodule DirtyDriver.Browser do
  use Task

  alias DirtyDriver.MintHelper
  alias DirtyDriver.ConnectionAgent
  alias DirtyDriver.SessionAgent
  alias DirtyDriver.Commands

  def start_link(args) do
    Task.start_link(__MODULE__, :start, [args])
  end

  def start(args) do
    if args == "firefox" do
      System.cmd("geckodriver", [])
    end
  end

  def end_driver do
    Commands.delete_session()
    {:ok, conn} = Mint.HTTP.close(ConnectionAgent.conn())

    {pid, _} = System.cmd("pidof", ["geckodriver"])
    System.cmd("kill", ["-9", String.trim(pid)])
  end

  def open_browser(name) do
    start_link(name)
    conn = MintHelper.connect_to_session()
    ConnectionAgent.start_link(conn)
    session_data = Commands.start_session()
    SessionAgent.start_link(session_data["value"]["sessionId"])
  end

  def go_to(url) do
    Commands.set_url(url)
  end

end
