defmodule Chord.Distance.Simple do
  def distance(chord, chord),
    do: 0

  def distance([fret_a | rest_a], [fret_b | rest_b]),
    do: distance(fret_a, fret_b) + distance(rest_a, rest_b)

  def distance(nil, fret),
    do: 1

  def distance(fret, nil),
    do: 1

  def distance(fret_a, fret_b),
    do: abs(fret_a - fret_b)
end
