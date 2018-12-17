max_temp = 1
n = 100_00

pairs = [
  {
    [nil, {3, 1}, {5, 3}, {5, 4}, {4, 2}, nil],
    [nil, 3, 5, 3, 4, nil],
    [
      [nil, {3, 1}, {5, 3}, {3, 1}, {4, 2}, nil],
      [nil, {3, 1}, {5, 4}, {3, 1}, {4, 3}, nil],
      [nil, {3, 1}, {5, 4}, {3, 1}, {4, 2}, nil],
      [nil, {3, 1}, {5, 4}, {3, 2}, {4, 3}, nil],
      [nil, {3, 2}, {5, 4}, {3, 1}, {4, 3}, nil],
      [nil, {3, 2}, {5, 4}, {3, 2}, {4, 3}, nil]
    ]
  },
  {
    [nil, {5, 2}, {5, 3}, {4, 1}, {6, 4}, nil],
    [nil, 3, 5, 5, 5, nil],
    [
      [nil, {3, 1}, {5, 3}, {5, 3}, {5, 3}, nil],
      [nil, {3, 1}, {5, 2}, {5, 3}, {5, 4}, nil],
      [nil, {3, 2}, {5, 3}, {5, 3}, {5, 4}, nil],
      [nil, {3, 1}, {5, 3}, {5, 2}, {5, 4}, nil],
      [nil, {3, 1}, {5, 3}, {5, 3}, {5, 4}, nil],
      [nil, {3, 2}, {5, 3}, {5, 3}, {5, 3}, nil],
      [nil, {3, 2}, {5, 3}, {5, 4}, {5, 3}, nil],
      [nil, {3, 2}, {5, 3}, {5, 4}, {5, 4}, nil],
      [nil, {3, 1}, {5, 3}, {5, 2}, {5, 2}, nil],
      [nil, {3, 1}, {5, 3}, {5, 2}, {5, 3}, nil],
      [nil, {3, 1}, {5, 3}, {5, 3}, {5, 2}, nil],
      [nil, {3, 1}, {5, 3}, {5, 4}, {5, 2}, nil],
      [nil, {3, 1}, {5, 3}, {5, 4}, {5, 3}, nil],
      [nil, {3, 1}, {5, 3}, {5, 4}, {5, 4}, nil],
      [nil, {3, 1}, {5, 2}, {5, 2}, {5, 4}, nil],
      [nil, {3, 1}, {5, 2}, {5, 2}, {5, 2}, nil],
      [nil, {3, 1}, {5, 2}, {5, 2}, {5, 3}, nil],
      [nil, {3, 1}, {5, 2}, {5, 3}, {5, 2}, nil],
      [nil, {3, 1}, {5, 2}, {5, 3}, {5, 3}, nil],
      [nil, {3, 1}, {5, 2}, {5, 4}, {5, 2}, nil],
      [nil, {3, 1}, {5, 2}, {5, 4}, {5, 3}, nil],
      [nil, {3, 1}, {5, 2}, {5, 4}, {5, 4}, nil],
      [nil, {3, 2}, {5, 4}, {5, 3}, {5, 3}, nil],
      [nil, {3, 2}, {5, 4}, {5, 3}, {5, 4}, nil],
      [nil, {3, 2}, {5, 4}, {5, 4}, {5, 3}, nil],
      [nil, {3, 2}, {5, 4}, {5, 4}, {5, 4}, nil],
      [nil, {3, 1}, {5, 4}, {5, 2}, {5, 2}, nil],
      [nil, {3, 1}, {5, 4}, {5, 2}, {5, 3}, nil],
      [nil, {3, 1}, {5, 4}, {5, 2}, {5, 4}, nil],
      [nil, {3, 1}, {5, 4}, {5, 3}, {5, 2}, nil],
      [nil, {3, 1}, {5, 4}, {5, 3}, {5, 3}, nil],
      [nil, {3, 1}, {5, 4}, {5, 3}, {5, 4}, nil],
      [nil, {3, 1}, {5, 4}, {5, 4}, {5, 2}, nil],
      [nil, {3, 1}, {5, 4}, {5, 4}, {5, 3}, nil],
      [nil, {3, 1}, {5, 4}, {5, 4}, {5, 4}, nil],
      [nil, {3, 3}, {5, 4}, {5, 4}, {5, 4}, nil]
    ]
  }
]

:rand.seed(:exsplus, :os.timestamp())

# http://www.cleveralgorithms.com/nature-inspired/physical/simulated_annealing.html

neighbor = fn {place, lift, move_fret, move_string, move, lift_bar, place_bar} ->
  scale = 0.01

  {
    Enum.max([0, place + (:rand.uniform() - 0.5) * scale]),
    Enum.max([0, lift + (:rand.uniform() - 0.5) * scale]),
    Enum.max([0, move_fret + (:rand.uniform() - 0.5) * scale]),
    Enum.max([0, move_string + (:rand.uniform() - 0.5) * scale]),
    Enum.max([0, move + (:rand.uniform() - 0.5) * scale]),
    Enum.max([0, lift_bar + (:rand.uniform() - 0.5) * scale]),
    Enum.max([0, place_bar + (:rand.uniform() - 0.5) * scale])
  }
end

temperature = fn i -> (1 - i / (n + 1)) * max_temp end

strip_fingering = fn notes ->
  notes
  |> Enum.map(fn
    nil -> nil
    {nil, _} -> nil
    {fret, _} -> fret
    fret -> fret
  end)
end

cost = fn {place, lift, move_fret, move_string, move, lift_bar, place_bar} ->
  pairs
  |> Enum.map(fn {from, to, sorted} ->
    to
    |> Chord.Fingering.fingerings()
    |> Enum.map(
      &{Chord.Distance.Fingering.distance(
         from,
         &1,
         place: place,
         lift: lift,
         move_fret: move_fret,
         move_string: move_string,
         move: move,
         lift_bar: lift_bar,
         place_bar: place_bar
       ), &1}
    )
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Inversions.inversions(sorted)
  end)
  |> Enum.sum()
  |> Kernel./(length(pairs))
end

initial = {
  :rand.uniform(),
  :rand.uniform(),
  :rand.uniform(),
  :rand.uniform(),
  :rand.uniform(),
  :rand.uniform(),
  :rand.uniform()
}

stream =
  Stream.unfold(
    {
      initial,
      initial,
      :infinity,
      :infinity,
      0
    },
    fn {s_current, s_best, current_cost, best_cost, i} ->
      s_i = neighbor.(s_current)
      i_cost = cost.(s_i)
      t = temperature.(i)

      if i_cost <= current_cost do
        if i_cost < best_cost do
          IO.puts(i_cost)
          {s_i, {s_i, s_i, i_cost, i_cost, i + 1}}
        else
          {s_best, {s_i, s_best, i_cost, best_cost, i + 1}}
        end
      else
        if :math.exp((current_cost - i_cost) / t) > :rand.uniform() do
          {s_best, {s_i, s_best, i_cost, best_cost, i + 1}}
        else
          {s_best, {s_current, s_best, current_cost, best_cost, i + 1}}
        end
      end
    end
  )

IO.puts("Simulating...\n")

{
  place,
  lift,
  move_fret,
  move_string,
  move,
  lift_bar,
  place_bar
} =
  stream
  |> Enum.at(n)

IO.puts("Done!\n")

IO.puts("[")
IO.puts("  place: #{place},")
IO.puts("  lift: #{lift},")
IO.puts("  move_fret: #{move_fret},")
IO.puts("  move_string: #{move_string},")
IO.puts("  move: #{move}")
IO.puts("  lift_bar: #{lift_bar}")
IO.puts("  place_bar: #{place_bar}")
IO.puts("]")
