defmodule DiscordBot.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DiscordBot
    ]

    opts = [strategy: :one_for_one, name: DiscordBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
