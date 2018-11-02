Chord.Voicing.voicings([0, 4, {:optional, 7}, 11])
|> Enum.map(
  &{Chord.Measure.Notes.notes(&1), Chord.Measure.Spacing.spacing(&1),
   Chord.Measure.Invertedness.invertedness(&1, [0, 4, 7]), &1}
)
|> Enum.sort()
|> Enum.take(10)
|> IO.inspect()
