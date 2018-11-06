defmodule Chord.Distance.Semitone do
  def distance(chord, chord),
    do: 0

  def distance(chord_a, chord_b, strings \\ [40, 45, 50, 55, 59, 64]),
    do:
      [
        chord_to_notes(chord_a, strings),
        chord_to_notes(chord_b, strings)
      ]
      |> Enum.zip()
      |> Enum.map(fn {note_a, note_b} -> abs(note_a - note_b) end)
      |> Enum.sum()

  defp chord_to_notes(chord, strings),
    do:
      chord
      |> Enum.map(fn
        {fret, _finger} -> fret
        fret -> fret
      end)
      |> Enum.zip(strings)
      |> Enum.reject(fn
        {nil, _} -> true
        _ -> false
      end)
      |> Enum.map(fn {fret, base} -> base + fret end)
end
