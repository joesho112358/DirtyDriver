defmodule DirtyDriver.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    persistent_term =
      Code.ensure_loaded?(:persistent_term) and function_exported?(:persistent_term, :get, 2)

    Application.put_env(:dirty_driver, :persistent_term, persistent_term)

    opts = [strategy: :one_for_one, name: DirtyDriver.Supervisor]
    Supervisor.start_link([], opts)
  end
end
