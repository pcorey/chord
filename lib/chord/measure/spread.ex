defmodule Chord.Measure.Spread do
  @moduledoc """
  Spread refers to how spread out a chord is over the strings of the guitar. For example, `[8, nil, nil, nil, 12, 12]` is much more spread out than `[8, 7, 9, nil, nil, nil]`.
  """

  def spread([]),
    do: 0

  def spread(chord) do
    trim = trim(chord)
    notes = notes(chord)
    length = length(chord)
    compute_spread(trim, notes, length)
  end

  defp compute_spread(0, _, _),
    do: 0

  defp compute_spread(_, 0, _),
    do: 0

  defp compute_spread(_, _, 0),
    do: 0

  defp compute_spread(trim, notes, length),
    do: trim / notes / length

  defp trim(chord),
    do:
      chord
      |> Enum.reverse()
      |> Enum.drop_while(&(&1 == nil))
      |> Enum.reverse()
      |> Enum.drop_while(&(&1 == nil))
      |> length()

  defp notes(chord),
    do:
      chord
      |> Enum.reject(&(&1 == nil))
      |> length()
end
