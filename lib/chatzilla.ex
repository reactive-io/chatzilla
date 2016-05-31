defmodule Chatzilla do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Chatzilla.Endpoint, []),
      # Start the Ecto repository
      supervisor(Chatzilla.Repo, []),
      supervisor(Chatzilla.User, [])
      # Here you could define other workers and supervisors as children
      # worker(Chatzilla.Worker, [arg1, arg2, arg3]),
      # worker(Task, [fn -> IO.puts("Hello World!") end], restart: :transient)
      # supervisor(Task.Supervisor, [fn -> IO.puts("Hello World!") end])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Chatzilla.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Chatzilla.Endpoint.config_change(changed, removed)
    :ok
  end
end
