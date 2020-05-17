defmodule Chord.Note do
  @notes_map %{
    "C" => 0,
    "C#" => 1,
    "Db" => 1,
    "D" => 2,
    "D#" => 3,
    "Eb" => 3,
    "E" => 4,
    "F" => 5,
    "F#" => 6,
    "Gb" => 6,
    "G" => 7,
    "G#" => 8,
    "Ab" => 8,
    "A" => 9,
    "A#" => 10,
    "Bb" => 10,
    "B" => 11
  }

  @doc """
  Convert a not or a set of notes to its integer representation.

  ## Examples

      iex> Chord.Note.to_integer(["C", "Db", "D", "Eb"])
      [0, 1, 2, 3]

      iex> Chord.Note.to_integer("C#")
      1

  """
  def to_integer(notes) when is_list(notes), do: Enum.map(notes, fn note -> to_integer(note) end)

  def to_integer(note), do: Map.fetch!(@notes_map, note)
end
