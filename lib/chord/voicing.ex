defmodule Chord.Voicing do
  def voicings(notes, notes_in_chord \\ nil),
    do:
      notes
      |> all_note_sets()
      |> Enum.map(&build_chords/1)
      |> List.flatten()
      |> Enum.map(&Tuple.to_list/1)
      |> filter_notes_in_chord(notes_in_chord)

  defp filter_notes_in_chord(voicings, nil),
    do: voicings

  defp filter_notes_in_chord(voicings, notes_in_chord),
    do:
      voicings
      |> Enum.filter(fn voicing ->
        voicing
        |> Enum.reject(&(&1 == nil))
        |> length
        |> Kernel.==(notes_in_chord)
      end)

  defp build_chords(note_set, chord \\ [nil, nil, nil, nil, nil, nil], chords \\ [])

  defp build_chords([], chord, chords),
    do: [List.to_tuple(chord) | chords]

  defp build_chords([note | rest], chord, chords) do
    note
    |> all_notes()
    |> Enum.filter(fn {string, fret} -> Enum.at(chord, string) == nil end)
    |> Enum.map(fn {string, fret} ->
      new_chord = List.replace_at(chord, string, fret)

      {min, max} =
        new_chord
        |> Enum.reject(&(&1 == nil || &1 == 0))
        |> Enum.min_max(fn -> {0, 0} end)

      if max - min <= 4 do
        build_chords(rest, new_chord, chords)
      else
        chords
      end
    end)
    |> Enum.reject(&Enum.empty?/1)
  end

  defp all_note_sets(notes) do
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

  defp all_notes(target_note, strings \\ [40, 45, 50, 55, 59, 64], frets \\ 12) do
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
end
