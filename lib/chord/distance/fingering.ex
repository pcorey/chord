defmodule Chord.Distance.Fingering do
  @moduledoc """
  """

  @fingers 4
  @max_distance 100

  import Chord.Util

  def distance(chord_a, chord_b, options) do
    distance =
      chord_a
      |> edit_script(chord_b, options)
      |> script_to_distance(options)

    distance / @max_distance
  end

  def script_to_distance(script, options \\ [])

  def script_to_distance([], _options),
    do: 0

  def script_to_distance([{:lift, _} | rest], options),
    do: Keyword.get(options, :lift, 1) + script_to_distance(rest, options)

  def script_to_distance([{:place, _} | rest], options),
    do: Keyword.get(options, :place, 1) + script_to_distance(rest, options)

  def script_to_distance([{:slide, from, to} | rest], options) do
    [{from_fret, _, _} | _] = from
    [{to_fret, _, _} | _] = to
    fret_distance = abs(from_fret - to_fret)
    fret_distance * Keyword.get(options, :slide, 1) + script_to_distance(rest, options)
  end

  def script_to_distance([{:move, from, to} | rest], options) do
    [{from_fret, _, from_string} | _] = from
    [{to_fret, _, to_string} | _] = to
    fret_distance = abs(from_fret - to_fret)
    string_distance = abs(from_string - to_string)
    total_distance = fret_distance + string_distance
    total_distance * Keyword.get(options, :move, 1) + script_to_distance(rest, options)
  end

  def edit_script(chord_a, chord_b, options \\ [])

  def edit_script(chord, chord, _options),
    do: []

  def edit_script(from_chord, to_chord, _options) do
    for finger <- 1..@fingers do
      from_finger =
        from_chord
        |> attach_strings()
        |> find_finger(finger)

      to_finger =
        to_chord
        |> attach_strings()
        |> find_finger(finger)

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

  defp finger_diff(from = [{_, _, string} | _], to = [{_, _, string} | _]),
    do: {:slide, from, to}

  defp finger_diff(from, to),
    do: [{:lift, from}, {:move, from, to}, {:place, to}]
end
