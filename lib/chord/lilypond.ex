defmodule Chord.Lilypond do
  def to_string(chords) when is_list(chords) do
    staff =
      chords
      |> Enum.map(&chord_to_markup/1)

    """
      <<
        \\new Staff {
    #{staff}
        }
      >>
    """
  end

  defp chord_to_markup(chord) do
    diagram =
      chord
      |> Enum.with_index()
      |> IO.inspect()
      |> Enum.map(&fret_to_markup/1)

    """
          <a'>1^\\markup {
            \\fret-diagram #"f:2;s:1;#{diagram}"
          }
    """
  end

  defp fret_to_markup({nil, string}),
    do: "#{string + 1}-o;"

  defp fret_to_markup({{0, nil}, string}),
    do: "#{string + 1}-o;"

  defp fret_to_markup({{fret, finger}, string}),
    do: "#{string + 1}-#{fret}-#{finger};"

  defp fret_to_markup({fret, string}),
    do: "#{string + 1}-#{fret};"
end
