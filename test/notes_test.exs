defmodule NotesTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Chord.Measure.Notes

  defp chord(length),
    do:
      list_of(
        one_of([
          constant(nil),
          integer(0..12),
          {constant(0), constant(nil)},
          {constant(nil), constant(nil)},
          {integer(0..12), integer(0..4)}
        ]),
        length: length
      )

  property "gives a unit score" do
    check all(chord <- chord(6)) do
      score = Chord.Measure.Notes.notes(chord)
      assert score >= 0
      assert score <= 1
    end
  end
end
