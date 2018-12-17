defmodule Chord.Voicing do
  @tuning [40, 45, 50, 55, 59, 64]

  def voicings(notes, notes_in_chord \\ nil),
    do:
      notes
      |> all_note_sets()
      |> Enum.map(&build_chords/1)
      |> List.flatten()
      |> Enum.map(&Tuple.to_list/1)
      |> filter_highest_and_lowest(notes, :lowest)
      |> filter_highest_and_lowest(notes, :highest)
      |> Enum.uniq()

  defp get_note_with_option(notes, option),
    do:
      notes
      |> Enum.filter(fn
        {^option, note} -> true
        _ -> false
      end)
      |> Enum.map(fn {_, note} -> note end)
      |> List.first()

  defp filter_highest_and_lowest(voicings, notes, option),
    do:
      filter_highest_and_lowest(
        voicings,
        notes,
        option,
        get_note_with_option(notes, option)
      )

  defp filter_highest_and_lowest(voicings, _notes, _option, nil),
    do: voicings

  defp filter_highest_and_lowest(voicings, _notes, option, target_note),
    do:
      voicings
      |> Enum.filter(fn voicing ->
        [note | _] =
          voicing
          |> voicing_to_notes()
          |> orient_notes(option)

        note == target_note || rem(note, 12) == target_note
      end)

  defp voicing_to_notes(voicing),
    do:
      voicing
      |> Enum.zip(@tuning)
      |> Enum.map(fn
        {nil, open} -> nil
        {fret, open} -> fret + open
      end)
      |> Enum.reject(&(&1 == nil))

  defp orient_notes(notes, :lowest),
    do: notes

  defp orient_notes(notes, :highest),
    do: Enum.reverse(notes)

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

  def all_note_sets(notes) do
    required_notes =
      notes
      |> Enum.filter(fn
        {:optional, note} -> false
        _ -> true
      end)
      |> Enum.map(fn
        {_, note} -> note
        note -> note
      end)

    optional_notes =
      Enum.filter(notes, fn
        {:optional, note} -> true
        _ -> false
      end)

    all_notes =
      Enum.map(notes, fn
        {_, note} -> note
        note -> note
      end)

    if required_notes |> length <= 6 do
      for length <- length(required_notes)..6,
          tail <- Permutation.generate(all_notes, length - length(required_notes), true) do
        required_notes ++ tail
      end
    else
      []
    end
  end

  defp all_notes(target_note, strings \\ @tuning, frets \\ 18) do
    fretboard =
      for fret <- 0..frets,
          do: Enum.map(strings, &(&1 + fret))

    fretboard
    |> Enum.with_index()
    |> Enum.map(fn {fret_row, index} ->
      fret_row
      |> Enum.with_index()
      |> Enum.map(fn {note, string} ->
        cond do
          rem(note, 12) == target_note -> {string, index}
          note == target_note -> {string, index}
          true -> nil
        end
      end)
    end)
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end
end
