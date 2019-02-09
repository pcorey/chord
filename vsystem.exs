defmodule Fretboard do
  def to_string(fretboard) do
    for {frets, s} <- Enum.with_index(fretboard) do
      for {fret, f} <- Enum.with_index(frets) do
        cond do
          s == 0 ->
            cond do
              f == 0 ->
                case fret do
                  true -> "○"
                  false -> "┌"
                end

              f == length(List.first(fretboard)) - 1 ->
                case fret do
                  true -> "─●─┐"
                  false -> "───┐"
                end

              true ->
                case fret do
                  true -> "─●─┬"
                  false -> "───┬"
                end
            end

          s == length(fretboard) - 1 ->
            cond do
              f == 0 ->
                case fret do
                  true -> "○"
                  false -> "└"
                end

              f == length(List.first(fretboard)) - 1 ->
                case fret do
                  true -> "─●─┘"
                  false -> "───┘"
                end

              true ->
                case fret do
                  true -> "─●─┴"
                  false -> "───┴"
                end
            end

          true ->
            cond do
              f == 0 ->
                case fret do
                  true -> "○"
                  false -> "├"
                end

              f == length(List.first(fretboard)) - 1 ->
                case fret do
                  true -> "─●─┤"
                  false -> "───┤"
                end

              true ->
                case fret do
                  true -> "─●─┼"
                  false -> "───┼"
                end
            end
        end
      end ++ "\n"
    end
  end

  def new(strings, frets) do
    false
    |> List.duplicate(frets)
    |> List.duplicate(strings)
  end
end

defmodule VSystem do
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
    |> VSystem.mask(gaps)
    |> VSystem.fit_to_strings(strings)
  end

  def chords(root, quality, gaps, strings, frets) do
    IO.puts("strings #{inspect(strings)}")
    arpeggio = VSystem.arpeggiate(root, quality)

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

arpeggio = VSystem.arpeggiate(67, [3, 4, 3, 2])

# arpeggio
# |> Enum.take(10)
# |> IO.inspect()

# arpeggio
# |> VSystem.mask([1, 0, 1])
# |> IO.inspect()

# Fretboard.to_string([
#   [false, false, false, false, false, false, false, false],
#   [false, true, false, false, false, false, false, false],
#   [true, false, false, false, false, false, false, false],
#   [false, false, true, false, false, false, false, false],
#   [false, false, false, true, false, false, false, false],
#   [false, false, false, false, false, false, false, false]
# ])
# |> IO.puts()

# Fretboard.new(6, 12)
# |> Fretboard.to_string()
# |> IO.puts()

# arpeggio
# |> VSystem.mask([1, 0, 1])
# |> Enum.take(10)
# |> IO.inspect()

root = 0
quality = [4, 3, 4, 1]
gaps = [1, 0, 1]

# gap_map =
#   gaps
#   |> Enum.map(&([true] ++ List.duplicate(false, &1)))
#   |> Kernel.++([true])
#   |> List.flatten()
#   |> IO.inspect()

# [0]
# |> Stream.concat(Stream.cycle([4, 3, 4, 1]))
# |> Stream.scan(&Kernel.+/2)
# |> Stream.map(&(root + &1))
# |> Stream.zip(Stream.cycle(gap_map))
# |> Stream.filter(&elem(&1, 1))
# |> Stream.map(&elem(&1, 0))
# |> Stream.take(10)
# |> Enum.to_list()
# |> IO.inspect()

tuning = [40, 45, 50, 55, 59, 64]

# arpeggio
# |> Stream.drop(18)
# |> (fn a ->
#       b =
#         a
#         |> Stream.take(4)
#         |> Enum.to_list()

#       IO.inspect(b ++ 0)
#       a
#     end).()
# |> VSystem.mask([1, 0, 1])
# |> (fn a ->
#       IO.inspect(a ++ 0)
#       a
#     end).()
# |> IO.inspect()
# |> VSystem.fit_to_strings([nil, nil, 50, 55, 59, 64])
# |> IO.inspect()
# |> Chord.Renderer.to_string()
# |> IO.puts()

top_four = [nil, nil, 50, 55, 59, 64]
middle_four = [nil, 45, 50, 55, 59, nil]

VSystem.chords(60, [4, 3, 4, 1], [1, 0, 1], middle_four, 12)
|> Enum.map(&Chord.Renderer.to_string/1)
|> Enum.map(&IO.puts/1)
