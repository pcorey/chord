[0, 4, 7, 11]
|> Chord.voicings(4)
|> Enum.map(&{Chord.Distance.Semitone.distance(&1, [nil, 10, 12, 10, 12, nil]), &1})
|> Enum.uniq()
|> Enum.sort()
|> Enum.chunk_by(&elem(&1, 0))
|> List.first()
|> Enum.map(&elem(&1, 1))
|> Enum.map(fn chord ->
  chord
  |> Chord.fingerings()
  |> Enum.uniq()
  |> Enum.map(
    &{Chord.Distance.Fingering.distance(&1, [nil, {10, 1}, {12, 3}, {10, 1}, {12, 4}, nil]), &1}
  )
end)
|> List.flatten()
|> Enum.sort()
|> Enum.chunk_by(&elem(&1, 0))
|> List.first()
|> Enum.map(&elem(&1, 1))
|> Enum.map(&Chord.to_string/1)
|> Enum.join("\n\n")
|> IO.puts()
