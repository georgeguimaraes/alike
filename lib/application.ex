defmodule Alike.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LanguageModel.Model.child_spec()
    ]

    opts = [strategy: :one_for_one, name: Alike.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
