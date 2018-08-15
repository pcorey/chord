defmodule Chord.Distance do
  def fingering_distance(chord_a, chord_b),
    do: Chord.Distance.Fingering.distance(chord_a, chord_b)
end
