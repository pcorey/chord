defmodule Chord.Distance.Fifths do
  def distance(chord, chord),
    do: 0

  def distance(chord_a, chord_b, strings \\ [40, 45, 50, 55, 59, 64]),
    do:
      [
        chord_to_notes(chord_a, strings),
        chord_to_notes(chord_b, strings)
      ]
      |> Enum.zip()
      |> Enum.map(fn {note_a, note_b} -> count_fifths(note_a, note_b) end)
      |> Enum.sum()

  defp chord_to_notes(chord, strings),
    do:
      chord
      |> Enum.zip(strings)
      |> Enum.reject(fn
        {nil, _} -> true
        _ -> false
      end)
      |> Enum.map(fn {fret, base} -> base + fret end)

  defp count_fifths(a, b)

  defp count_fifths(a, a),
    do: 0

  defp count_fifths(a, b) when a > 12,
    do: count_fifths(rem(a, 12), b)

  defp count_fifths(a, b) when b > 12,
    do: count_fifths(a, rem(b, 12))

  defp count_fifths(a, b),
    do: 1 + count_fifths(rem(a + 7, 12), b)
end
