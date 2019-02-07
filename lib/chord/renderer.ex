# http://www.alanflavell.org.uk/unicode/unidata25.html
# https://en.wikipedia.org/wiki/Chord_names_and_symbols_(popular_music)

defmodule Chord.Renderer do
  def to_string(chord, chord_name \\ nil) do
    {min, max} =
      chord
      |> Enum.map(fn
        {fret, finger} -> fret
        fret -> fret
      end)
      |> Enum.reject(&(&1 == nil))
      |> Enum.min_max()

    0..max(max - min, 3)
    |> Enum.map(&row_to_string(&1, min, chord, chord_name))
    |> Enum.intersperse([:bright, :black, "\n   ├┼┼┼┼┤\n"])
    |> append_fingering(chord)
    |> IO.ANSI.format(false)
    |> IO.chardata_to_string()
  end

  defp row_to_string(offset, base, chord, chord_name),
    do: [
      left_gutter(offset, base + offset),
      Enum.map(chord, &fret_to_string(&1, base + offset)),
      right_gutter(offset, chord_name)
    ]

  defp fret_to_string(nil, 0),
    do: [:bright, :black, "┬"]

  defp fret_to_string(nil, _fret),
    do: [:bright, :black, "│"]

  defp fret_to_string({note, finger}, fret) when note == fret,
    do: [:bright, :white, "●"]

  defp fret_to_string(note, fret) when note == fret,
    do: [:bright, :white, "●"]

  defp fret_to_string(_note, 0),
    do: [:bright, :black, "┬"]

  defp fret_to_string(_note, _fret),
    do: [:bright, :black, "│"]

  defp left_gutter(_, 0),
    do: "   "

  defp left_gutter(0, fret),
    do: [:bright, :yellow, String.pad_leading("#{fret}", 2, " ") <> " "]

  defp left_gutter(_, _),
    do: "   "

  defp right_gutter(0, chord_name),
    do: [:yellow, " #{chord_name}"]

  defp right_gutter(_, _),
    do: ""

  defp append_fingering(lines, chord),
    do:
      lines ++
        [:reset, "\n   "] ++
        (chord
         |> Enum.map(fn
           {_fret, nil} -> " "
           {_fret, finger} -> "#{finger}"
           _ -> " "
         end))
end
