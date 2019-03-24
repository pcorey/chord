defmodule Chord.Table do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    table = :ets.new(:chords, [:protected, :bag])

    Chords.generate()
    |> Enum.map(&:ets.insert(table, {&1.root, &1}))

    IO.puts("All voicings generated.")

    {:ok, table}
  end

  def insert(data) do
    GenServer.call(__MODULE__, {:insert, data})
  end

  def lookup(key) do
    GenServer.call(__MODULE__, {:lookup, key})
  end

  def table() do
    GenServer.call(__MODULE__, {:table})
  end

  def handle_call({:insert, data}, _from, table) do
    result = :ets.insert(table, data)
    {:reply, result, table}
  end

  def handle_call({:lookup, key}, _from, table) do
    result = :ets.lookup(table, key)
    {:reply, result, table}
  end

  def handle_call({:table}, _from, table) do
    {:reply, table, table}
  end
end
