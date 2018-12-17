progression = [
  [{8, 1}, nil, {10, 3}, {9, 2}, {8, 1}, nil],
  [nil, {7, 1}, {9, 3}, {7, 1}, {8, 2}, nil],
  [nil, {8, 3}, {7, 2}, {5, 1}, {8, 4}, nil],
  [{3, 1}, {5, 3}, {3, 1}, {5, 4}, nil, nil],
  [{3, 1}, {5, 3}, {4, 2}, {5, 4}, nil, nil]
]

strip_fingering = fn notes ->
  notes
  |> Enum.map(fn
    nil -> nil
    {nil, _} -> nil
    {note, _} -> note
    note -> note
  end)
end

progression
|> Enum.chunk_every(2, 1, :discard)
|> Enum.map(fn [from, to] ->
  to
  |> strip_fingering.()
  |> Chord.Fingering.fingerings()
  |> List.delete(to)
  |> Enum.map(&Chord.Distance.Fingering.distance(from, &1))
end)
|> IO.inspect()
