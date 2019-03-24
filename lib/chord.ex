defmodule Chord do
  defstruct root: nil,
            quality: nil,
            gaps: nil,
            strings: nil,
            chord: nil

  @tuning [40, 45, 50, 55, 59, 64]

  def to_string(chord, chord_name \\ nil),
    do: Chord.Renderer.to_string(chord, chord_name)

  def to_notes(chord) do
    chord
    |> Map.fetch!(:chord)
    |> Enum.zip(@tuning)
    |> Enum.reject(fn
      {nil, _} -> true
      _ -> false
    end)
    |> Enum.map(fn {fret, open} -> fret + open end)
  end
end
