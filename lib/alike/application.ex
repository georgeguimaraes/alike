defmodule Alike.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    # Models are loaded lazily on first use
    children = []

    opts = [strategy: :one_for_one, name: Alike.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
