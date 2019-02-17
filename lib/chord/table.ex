defmodule Chord.Table do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    table = :ets.new(:chords, [:set, :protected])

    Chords.generate()
    |> Enum.map(&:ets.insert(table, {&1, &1}))

    {:ok, table}
  end

  def insert(data) do
    GenServer.call(__MODULE__, {:insert, data})
  end

  def select(selector) do
    GenServer.call(__MODULE__, {:select, selector})
  end

  def handle_call({:insert, data}, _from, table) do
    result = :ets.insert(table, data)
    {:reply, result, table}
  end

  def handle_call({:select, selector}, _from, table) do
    result = :ets.select(table, selector)
    {:reply, result, table}
  end
end
