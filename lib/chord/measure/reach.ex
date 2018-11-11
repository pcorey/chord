defmodule Chord.Measure.Reach do
  @moduledoc """
  Reach refers to how reach out a chord is across the fretboard. For example, `[nil, 10, 10, 8, 11, nil]` is much more reach out than `[8, nil, 8, 8, 8, nil]`.
  """

  def reach(chord),
    do:
      chord
      |> Enum.map(fn
        {fret, _finger} -> fret
        fret -> fret
      end)
      |> Enum.filter(fn
        nil -> false
        0 -> false
        fret -> true
      end)
      |> do_reach

  defp do_reach([]),
    do: 0

  defp do_reach(chord),
    do:
      chord
      |> Enum.min_max()
      |> (fn {min, max} -> max - min end).()
      |> Kernel./(5)
end
