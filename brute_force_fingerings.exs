pairs = [
  {
    [nil, {3, 1}, {5, 3}, {5, 4}, {4, 2}, nil],
    [nil, {3, 1}, {5, 3}, {3, 1}, {4, 2}, nil]
  },
  {
    [nil, {5, 2}, {5, 3}, {4, 1}, {6, 4}, nil],
    [nil, {3, 1}, {5, 3}, {5, 3}, {5, 3}, nil]
  },
  {
    [nil, {10, 2}, {10, 3}, {9, 1}, {12, 4}, nil],
    [nil, {12, 2}, {12, 3}, {10, 1}, {13, 4}, nil]
  }
]

# `options` can be:
# - `:noop`
# - `:place`
# - `:lift`
# - `:move_string`
# - `:move_fret`
# - `:move`
# - `:lift_bar`
# - `:place_bar`

:rand.seed(:exsplus, :os.timestamp())

strip_fingering = fn chord ->
  chord
  |> Enum.map(fn
    {fret, _} -> fret
    nil -> nil
  end)
end

attempt = fn attempt ->
  options = [
    noop: :rand.uniform(),
    place: :rand.uniform(),
    lift: :rand.uniform(),
    move_string: :rand.uniform(),
    move_fret: :rand.uniform(),
    lift_bar: :rand.uniform(),
    place_bar: :rand.uniform()
  ]

  wrong =
    pairs
    |> Enum.reject(fn {from, to} ->
      to
      |> strip_fingering.()
      |> Chord.Fingering.fingerings()
      |> Enum.map(&{Chord.Distance.Fingering.distance(from, &1, options), &1})
      |> Enum.sort()
      |> Enum.at(0)
      |> elem(1)
      |> Kernel.==(to)
    end)

  if wrong == [] do
    IO.puts("Victory!")
    IO.inspect(options)
  else
    attempt.(attempt)
  end
end

attempt.(attempt)
