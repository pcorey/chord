defmodule Chord.Measure.Invertedness do
  @moduledoc """
  The "invertedness" of a chord represents how far away from its stacked-third form a given chord is. Let's say we're working with a Cmaj7 chord and the notes in the chord are `[60, 64, 67, 71]`. Because this is nothing more than stacked thirds, this chord has a low "invertedness" measure.

  If we invert the fifth below the root, we'll have a slightly higher "invertedness" value.

  We calculate a chord's invertedness by taking the notes of that chord, and it's intended root. We calculate the intervals between the root and the notes in the chord. Those intervals are then mapped to weights.

  0 -> unison
  1 -> b9, not b2
  1 -> 9, not 2
  1 -> b3
  1 -> 3
  1 -> # 11, not 4. What about b11? If b3 already exists, use b11...
  1 -> # Always b5, never #4
  1 -> 5
  1 -> b13, not b6
  1 -> 13, not 6
  1 -> b7
  1 -> b8
  """

  def invertedness(chord, [root | _]),
    do: invertedness(chord, root)

  def invertedness(chord, root) do
    chord
    |> notes
    |> Enum.map(&to_pitch_class/1)
    |> Enum.map(&invert_above_root(&1, root))
    |> Enum.map(&(&1 - root))
    # Pure thirds:
    # |> Enum.map(fn
    #   0 -> 0
    #   1 -> 4
    #   2 -> 4
    #   3 -> 1
    #   4 -> 1
    #   5 -> 5
    #   6 -> 2
    #   7 -> 2
    #   8 -> 6
    #   9 -> 6
    #   10 -> 3
    #   11 -> 3
    # end)
    # By "dissonance":
    |> Enum.map(fn
      0 -> 0
      1 -> 7
      2 -> 5
      3 -> 4
      4 -> 3
      5 -> 2
      6 -> 8
      7 -> 1
      8 -> 4
      9 -> 2
      10 -> 6
      11 -> 5
    end)
    |> score()
  end

  defp notes(chord, strings \\ [40, 45, 50, 55, 59, 64]),
    do:
      chord
      |> Enum.map(fn
        {note, _finger} -> note
        note -> note
      end)
      |> Enum.with_index()
      |> Enum.map(fn
        {nil, _string} -> nil
        {{note, _finger}, string} -> note + Enum.at(strings, string)
        {note, string} -> note + Enum.at(strings, string)
      end)
      |> Enum.reject(&(&1 == nil))

  defp to_pitch_class(note),
    do: rem(note, 12)

  defp invert_above_root(note, root) when note < root,
    do: note + 12

  defp invert_above_root(note, root),
    do: note

  defp score(invertedness) do
    invertedness
    |> Enum.with_index()
    |> Enum.map(fn
      {0, _} -> 0
      {d, i} -> d / 8 * (1 / (i + 1))
    end)
    |> Enum.sum()
    |> compute_score(base_score(invertedness))
  end

  defp compute_score(score, 0),
    do: 0

  defp compute_score(score, base),
    do: score / base

  defp base_score(invertedness) do
    invertedness
    |> Enum.with_index()
    |> Enum.map(fn
      {0, _} -> 8
      {_d, i} -> 1 / (i + 1)
    end)
    |> Enum.sum()
  end
end
