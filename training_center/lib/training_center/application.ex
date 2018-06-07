defmodule TrainingCenter.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(TrainingCenterWeb.Endpoint, []),
      supervisor(TrainingCenterWeb.Presence, [])
    ]

    opts = [strategy: :one_for_one, name: TrainingCenter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TrainingCenterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
