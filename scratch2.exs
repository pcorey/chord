Chord.Voicing.voicings([0, 4, {:optional, 7}, 11])
|> Enum.map(
  &{Chord.Measure.Notes.notes(&1), Chord.Measure.Spacing.spacing(&1),
   Chord.Measure.Invertedness.invertedness(&1, [0, 4, 7]), &1}
)
|> Enum.sort()
|> Enum.take(10)
|> IO.inspect()

#
# Ideal interface (?):
#

from_chord = [nil, {3, 3}, {2, 2}, {0, nil}, {1, nil}, nil]

[0, 4, {:optional, 7}, 11]
|> Chord.voicings()
|> Chord.fingerings()
|> Chord.sort_by(&Chord.Measure.musical_distance(&1, from_chord))
|> Chord.sort_by(&Chord.Measure.fingering_distance(&1, from_chord))
|> Chord.sort_by(&Chord.Measure.notes(&1))
|> Chord.sort_by(&Chord.Measure.spacing(&1))
|> Chord.sort_by(&Chord.Measure.invertedness(&1, [0, 4, 7, 11]))

[0, 4, {:optional, 7}, 11]
|> Chord.voicings()
|> Chord.fingerings()
|> Chord.wrap_with(&Chord.Measure.musical_distance(&1, from_chord))
|> Chord.wrap_with(&Chord.Measure.fingering_distance(&1, from_chord))
|> Chord.wrap_with(&Chord.Measure.notes(&1))
|> Chord.wrap_with(&Chord.Measure.spacing(&1))
|> Chord.wrap_with(&Chord.Measure.invertedness(&1, [0, 4, 7, 11]))
|> Enum.sort()
|> Chord.strip_wrappings()
