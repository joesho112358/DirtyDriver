defmodule DirtyDriver.TestServer do
  @config [
    port: 5555,
    server_root: String.to_charlist(Path.absname(".", __DIR__)),
    document_root: String.to_charlist(Path.absname("./pages", __DIR__)),
    server_name: 'test',
    directory_index: ['index.html']
  ]

  def start do
    :inets.start
    case :inets.start(:httpd, @config) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def stop(pid) do
    :ok = :inets.stop(:httpd, pid)
  end

  def stop do
    :ok = :inets.stop(:httpd, {{127,0,0,1}, 5555})
  end
end
