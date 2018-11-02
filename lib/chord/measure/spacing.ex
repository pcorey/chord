defmodule Chord.Measure.Spacing do
  @moduledoc """
  Spacing refers to how spread out a chord is over the strings of the guitar. For example, `[8, nil, nil, nil, 12, 12]` is much more spread out than `[8, 7, 9, nil, nil, nil]`.
  """

  def spacing(chord),
    do: trim(chord) / notes(chord) / length(chord)

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
