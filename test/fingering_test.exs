defmodule FingeringTest do
  import Chord.Distance.Fingering

  use ExUnit.Case

  doctest Chord.Distance.Fingering

  describe "edit_script" do
    test "returns empty edit_script" do
      assert edit_script([], []) == []
    end

    test "place a finger" do
      assert edit_script([nil], [{1, 1}]) == [{:place, [{1, 1, 0}]}]
    end

    test "place multiple fingers" do
      assert edit_script([nil, nil], [{1, 2}, {2, 3}]) == [
               {:place, [{1, 2, 0}]},
               {:place, [{2, 3, 1}]}
             ]
    end

    test "lift a finger" do
      assert edit_script([{1, 1}], [nil]) == [{:lift, [{1, 1, 0}]}]
    end

    test "lift a finger for open fret" do
      assert edit_script([{1, 1}], [{0, nil}]) == [{:lift, [{1, 1, 0}]}]
    end

    test "lift multiple fingers" do
      assert edit_script([{1, 2}, {2, 3}], [nil, nil]) == [
               {:lift, [{1, 2, 0}]},
               {:lift, [{2, 3, 1}]}
             ]
    end

    test "move a finger" do
      assert edit_script([{1, 1}, nil], [nil, {1, 1}]) == [
               {:lift, [{1, 1, 0}]},
               {:move, [{1, 1, 0}], [{1, 1, 1}]},
               {:place, [{1, 1, 1}]}
             ]
    end

    test "slide a finger" do
      assert edit_script([{1, 1}], [{2, 1}]) == [
               {:slide, [{1, 1, 0}], [{2, 1, 0}]}
             ]
    end

    test "place a bar" do
      assert edit_script([nil, nil], [{1, 1}, {1, 1}]) == [{:place, [{1, 1, 0}, {1, 1, 1}]}]
    end

    test "lift a bar" do
      assert edit_script([{1, 1}, {1, 1}], [nil, nil]) == [{:lift, [{1, 1, 0}, {1, 1, 1}]}]
    end

    test "A major to A minor" do
      a_major = [nil, {0, nil}, {2, 1}, {2, 1}, {2, 1}, nil]
      a_minor = [nil, {0, nil}, {2, 2}, {2, 3}, {1, 1}, nil]

      assert edit_script(a_major, a_minor) == [
               {:lift, [{2, 1, 2}, {2, 1, 3}, {2, 1, 4}]},
               {:move, [{2, 1, 2}, {2, 1, 3}, {2, 1, 4}], [{1, 1, 4}]},
               {:place, [{1, 1, 4}]},
               {:place, [{2, 2, 2}]},
               {:place, [{2, 3, 3}]}
             ]
    end

    test "A major to A major 7" do
      a_major = [nil, {0, nil}, {2, 1}, {2, 1}, {2, 1}, nil]
      a_major_7 = [nil, {0, nil}, {2, 2}, {1, 1}, {2, 3}, nil]

      assert edit_script(a_major, a_major_7) ==
               [
                 {:lift, [{2, 1, 2}, {2, 1, 3}, {2, 1, 4}]},
                 {:move, [{2, 1, 2}, {2, 1, 3}, {2, 1, 4}], [{1, 1, 3}]},
                 {:place, [{1, 1, 3}]},
                 {:place, [{2, 2, 2}]},
                 {:place, [{2, 3, 4}]}
               ]
    end

    test "slide bar" do
      from = [{2, 1}, {2, 1}, {2, 1}]
      to = [{3, 1}, {3, 1}, {3, 1}]

      assert edit_script(from, to) == [
               {:slide, [{2, 1, 0}, {2, 1, 1}, {2, 1, 2}], [{3, 1, 0}, {3, 1, 1}, {3, 1, 2}]}
             ]
    end

    test "move bar" do
      from = [nil, {2, 1}, {2, 1}, {2, 1}]
      to = [{3, 1}, {3, 1}, {3, 1}, {3, 1}]

      assert edit_script(from, to) ==
               [
                 {:lift, [{2, 1, 1}, {2, 1, 2}, {2, 1, 3}]},
                 {:move, [{2, 1, 1}, {2, 1, 2}, {2, 1, 3}],
                  [{3, 1, 0}, {3, 1, 1}, {3, 1, 2}, {3, 1, 3}]},
                 {:place, [{3, 1, 0}, {3, 1, 1}, {3, 1, 2}, {3, 1, 3}]}
               ]
    end

    test "slide bar and place" do
      from = [nil, {2, 1}, {2, 1}, {2, 1}]
      to = [nil, {3, 1}, {3, 1}, {4, 3}]

      assert edit_script(from, to) == [
               {:slide, [{2, 1, 1}, {2, 1, 2}, {2, 1, 3}], [{3, 1, 1}, {3, 1, 2}]},
               {:place, [{4, 3, 3}]}
             ]
    end
  end

  describe "script_to_distance" do
    test "returns empty edit_script" do
      script = edit_script([], [])
      assert script_to_distance(script) == 0
    end

    test "A major to A major 7" do
      a_major = [nil, {0, nil}, {2, 1}, {2, 1}, {2, 1}, nil]
      a_major_7 = [nil, {0, nil}, {2, 2}, {1, 1}, {2, 3}, nil]
      script = edit_script(a_major, a_major_7)
      assert script_to_distance(script) == 6
    end

    test "slide bar and place" do
      from = [nil, {2, 1}, {2, 1}, {2, 1}]
      to = [nil, {3, 1}, {3, 1}, {4, 3}]
      script = edit_script(from, to)
      assert script_to_distance(script) == 2
    end
  end
end
