defmodule Chord.Application do
  use Application

  def start(_type, _args) do
    children = [
      Chord.Table
    ]

    opts = [
      strategy: :one_for_one,
      name: Chord.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
