defmodule Chord do
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

  def voicings(notes) do
    notes
    |> all_note_sets
    |> Enum.map(&build_chords/1)
    |> List.flatten()
    |> Enum.map(&Tuple.to_list/1)
  end

  def build_chords(note_set, chord \\ [nil, nil, nil, nil, nil, nil], chords \\ [])

  def build_chords([], chord, chords),
    do: [List.to_tuple(chord) | chords]

  def build_chords([note | rest], chord, chords) do
    note
    |> all_notes
    |> Enum.filter(fn {string, fret} -> Enum.at(chord, string) == nil end)
    |> Enum.map(fn {string, fret} ->
      new_chord = List.replace_at(chord, string, fret)

      {min, max} =
        new_chord
        |> Enum.reject(&(&1 == nil))
        |> Enum.min_max(fn -> {0, 0} end)

      if max - min <= 5 do
        build_chords(rest, new_chord, chords)
      else
        chords
      end
    end)
    |> Enum.reject(&Enum.empty?/1)
  end

  def all_note_sets(notes) do
    for length <- 6..length(notes) do
      for base <- Combination.combine(notes, min(length, length(notes))) do
        for extension <- Combination.combine(notes, length - length(notes)) do
          base ++ extension
        end
      end
    end
    |> Enum.reduce(&Kernel.++/2)
    |> Enum.reduce(&Kernel.++/2)
  end

  def all_notes(target_note, strings \\ [40, 45, 50, 55, 59, 64], frets \\ 12) do
    fretboard =
      for fret <- 0..frets,
          do: Enum.map(strings, &(&1 + fret))

    fretboard
    |> Enum.with_index()
    |> Enum.map(fn {row, index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {note, string} ->
        if rem(note, 12) == target_note do
          {string, index}
        else
          nil
        end
      end)
    end)
    |> List.flatten()
    |> Enum.reject(&(&1 == nil))
  end

  def to_string(chord, chord_name \\ nil),
    do: Chord.Renderer.to_string(chord, chord_name)
end
