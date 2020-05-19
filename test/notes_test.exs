defmodule NotesTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Chord.Measure.Notes
  doctest Chord.Note

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

  describe "Chord.Note" do
    test "invalid note" do
      assert_raise KeyError, fn -> Chord.Note.to_integer("H#") end
      assert_raise KeyError, fn -> Chord.Note.to_integer("H") end
    end

    test "to_integer/1 passed to Chord.voicings/1" do
      first_voicing =
        Chord.Note.to_integer(["C", "Db", "D", "Eb"])
        |> Chord.voicings()
        |> List.first()

      assert [nil, 3, 0, 6, 4, nil] = first_voicing
    end
  end
end
