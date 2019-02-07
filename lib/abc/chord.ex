defmodule ABC.Chord do
  def parse(chord) do
    {root, rest} =
      chord
      |> String.downcase()
      |> parse_note()

    parse_type(rest, root)
  end

  defp parse_note("c" <> rest), do: parse_accidental(rest, 0)
  defp parse_note("d" <> rest), do: parse_accidental(rest, 2)
  defp parse_note("e" <> rest), do: parse_accidental(rest, 4)
  defp parse_note("f" <> rest), do: parse_accidental(rest, 5)
  defp parse_note("g" <> rest), do: parse_accidental(rest, 7)
  defp parse_note("a" <> rest), do: parse_accidental(rest, 9)
  defp parse_note("b" <> rest), do: parse_accidental(rest, 11)

  defp parse_accidental("b" <> rest, root),
    do: {root - 1, rest}

  defp parse_accidental("#" <> rest, root),
    do: {root + 1, rest}

  defp parse_accidental(rest, root),
    do: {root, rest}

  defp parse_type("maj7" <> rest, root),
    do:
      parse_slash(rest, [
        root |> add(0),
        root |> add(4),
        root |> add(7) |> optional(),
        root |> add(11)
      ])

  defp add(note, semitones),
    do: rem(note + semitones, 12)

  defp optional(note),
    do: {:optional, note}

  defp parse_slash("/" <> rest, chord) do
    {note, _rest} = parse_note(rest)

    chord
    |> Enum.reject(fn
      ^note -> true
      {:optional, ^note} -> true
      _ -> false
    end)
    |> Enum.concat([{:lowest, note}])
    |> List.flatten()
  end

  defp parse_slash(_rest, chord),
    do: chord
end
