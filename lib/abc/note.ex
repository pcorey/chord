defmodule ABC.Note do
  def parse(notes, key \\ [0, 0, 0, 0, 0, 0, 0])

  def parse("", _key),
    do: []

  def parse("C" <> rest, key),
    do: parse_octave(rest, 48 + Enum.at(key, 0), key)

  def parse("D" <> rest, key),
    do: parse_octave(rest, 50 + Enum.at(key, 1), key)

  def parse("E" <> rest, key),
    do: parse_octave(rest, 52 + Enum.at(key, 2), key)

  def parse("F" <> rest, key),
    do: parse_octave(rest, 53 + Enum.at(key, 3), key)

  def parse("G" <> rest, key),
    do: parse_octave(rest, 55 + Enum.at(key, 4), key)

  def parse("A" <> rest, key),
    do: parse_octave(rest, 57 + Enum.at(key, 5), key)

  def parse("B" <> rest, key),
    do: parse_octave(rest, 59 + Enum.at(key, 6), key)

  def parse("c" <> rest, key),
    do: parse_octave(rest, 60 + Enum.at(key, 0), key)

  def parse("d" <> rest, key),
    do: parse_octave(rest, 62 + Enum.at(key, 1), key)

  def parse("e" <> rest, key),
    do: parse_octave(rest, 64 + Enum.at(key, 2), key)

  def parse("f" <> rest, key),
    do: parse_octave(rest, 65 + Enum.at(key, 3), key)

  def parse("g" <> rest, key),
    do: parse_octave(rest, 67 + Enum.at(key, 4), key)

  def parse("a" <> rest, key),
    do: parse_octave(rest, 69 + Enum.at(key, 5), key)

  def parse("b" <> rest, key),
    do: parse_octave(rest, 71 + Enum.at(key, 6), key)

  defp parse_octave("'" <> rest, note, key),
    do: parse_octave(rest, note + 12, key)

  defp parse_octave("," <> rest, note, key),
    do: parse_octave(rest, note - 12, key)

  defp parse_octave(rest, note, key),
    do: [note] ++ parse(rest, key)
end
