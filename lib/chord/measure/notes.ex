defmodule Chord.Measure.Notes do
  @moduledoc """
  The "notes" measure measures how many notes are in a chord. A chord with zero notes has a notes measure of `0`, and a chord with `6` notes has a notes measure of `1`.
  """

  def notes(chord),
    do:
      chord
      |> Enum.reject(&(&1 == nil))
      |> length()
      |> Kernel./(length(chord))
end
