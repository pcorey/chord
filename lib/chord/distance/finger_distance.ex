defmodule Chord.Distance.FingerDistance do
  @doc """
  Ideas:
  - Simplify bar fingering by just looking at the first finger.
    - If the first finger moves, the bar moves.
    - If the first finger slides, the bar slides.
    - If there's only one finger, it's a finger, not a bar.
  """

  @fingers 4

  import Chord.Util

  def instructions(chord_a, chord_b, options \\ [])

  def instructions(chord, chord, _options),
    do: []

  def instructions(from_chord, to_chord, _options) do
    from_chord_with_strings = attach_strings(from_chord)
    to_chord_with_strings = attach_strings(to_chord)

    for finger <- 1..@fingers do
      from_finger = find_finger(from_chord_with_strings, finger)
      to_finger = find_finger(to_chord_with_strings, finger)
      finger_diff(from_finger, to_finger)
    end
    |> List.flatten()
  end

  defp find_finger(chord, finger) do
    chord
    |> Enum.filter(fn
      {_fret, ^finger, _string} -> true
      _ -> false
    end)
  end

  defp finger_diff(finger, finger),
    do: []

  defp finger_diff(from, []),
    do: {:lift, from}

  defp finger_diff(from, [{0, nil}]),
    do: {:lift, from}

  defp finger_diff([], to),
    do: {:place, to}

  defp finger_diff([{0, nil}], to),
    do: {:place, to}

  defp finger_diff(from, to) do
    get_string = fn {_fret, _finger, string} -> string end
    from_strings = Enum.map(from, get_string)
    to_strings = Enum.map(to, get_string)

    if List.first(from_strings) == List.first(to_strings) do
      {:slide, from, to}
    else
      [{:lift, from}, {:move, from, to}, {:place, to}]
    end
  end
end
