defmodule VoicingSystem do
  def arpeggiate(root, quality) do
    [rem(root, 12)]
    |> Stream.concat(Stream.cycle(quality))
    |> Stream.scan(&Kernel.+/2)
  end

  def mask(arpeggio, gaps) do
    gap_mask =
      gaps
      |> Enum.map(&([true] ++ List.duplicate(false, &1)))
      |> Kernel.++([true])
      |> List.flatten()

    arpeggio
    |> Stream.zip(Stream.cycle(gap_mask))
    |> Stream.filter(&elem(&1, 1))
    |> Stream.map(&elem(&1, 0))
    |> Enum.take(length(gaps) + 1)
  end

  def fit_to_strings(notes, strings) do
    strings
    |> Enum.reduce({notes, []}, fn
      nil, {notes, chord} ->
        {notes, chord ++ [nil]}

      open, {[note | notes], chord} ->
        {notes, chord ++ [note - open]}
    end)
    |> elem(1)
  end

  defp build_chord(drop, arpeggio, gaps, strings) do
    arpeggio
    |> Stream.drop(drop)
    |> mask(gaps)
    |> fit_to_strings(strings)
  end

  def chords(root, quality, gaps, strings, frets) do
    arpeggio = arpeggiate(root, quality)

    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&build_chord(&1, arpeggio, gaps, strings))
    |> Stream.drop_while(fn chord ->
      0 >
        chord
        |> Enum.reject(&is_nil/1)
        |> Enum.min()
    end)
    |> Stream.take_while(fn chord ->
      frets >=
        chord
        |> Enum.reject(&is_nil/1)
        |> Enum.max()
    end)
    |> Enum.to_list()
  end
end
