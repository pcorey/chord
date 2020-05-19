defmodule ReachTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Chord.Measure.Reach

  defp chord(length),
    do:
      list_of(
        one_of([
          constant(nil),
          integer(0..5),
          {constant(0), constant(nil)},
          {constant(nil), constant(nil)},
          {integer(0..5), integer(0..4)}
        ]),
        length: length
      )

  property "gives a unit score" do
    check all(chord <- chord(6)) do
      score = Chord.Measure.Reach.reach(chord)
      assert score >= 0
      assert score <= 1
    end
  end
end
