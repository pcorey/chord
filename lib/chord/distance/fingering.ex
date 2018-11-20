# https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Erlang
# https://nlp.stanford.edu/IR-book/html/htmledition/edit-distance-1.html

defmodule Chord.Distance.Fingering do
  @doc """
  `options` can be:
  - `:noop`
  - `:place`
  - `:lift`
  - `:move_string`
  - `:move_fret`
  - `:move`
  - `:lift_bar`
  - `:place_bar`
  """

  @fingers 4

  def distance(from_chord, to_chord, options \\ [])

  def distance(chord, chord, _options),
    do: 0

  def distance(from_chord, to_chord, options) do
    from_chord_with_strings = attach_strings(from_chord)
    to_chord_with_strings = attach_strings(to_chord)

    for finger <- 1..@fingers do
      from = find_fingers(from_chord_with_strings, finger)
      to = find_fingers(to_chord_with_strings, finger)
      d = finger_distance(from, to, options)
      d
    end
    |> Enum.sum()
  end

  defp attach_strings(chord),
    do:
      chord
      |> Enum.with_index()
      |> Enum.map(fn
        {{fret, finger}, string} -> {fret, finger, string}
        {nil, string} -> {nil, nil, string}
      end)

  defp find_fingers(chord, finger) do
    chord
    |> Enum.filter(fn
      {_fret, ^finger, _string} -> true
      _ -> false
    end)
  end

  # Noop
  defp finger_distance([], [], options) do
    Keyword.get(options, :noop, 0)
  end

  # Place
  defp finger_distance([], [_], options) do
    Keyword.get(options, :place, 1)
  end

  # Lift
  defp finger_distance([_], [], options) do
    Keyword.get(options, :lift, 1)
  end

  # Move
  defp finger_distance(
         [{fret_a, finger, string_a}],
         [{fret_b, finger, string_b}],
         options
       ) do
    string_distance = abs(string_a - string_b) * Keyword.get(options, :move_string, 1)
    fret_distance = abs(fret_a - fret_b) * Keyword.get(options, :move_fret, 1)

    (string_distance + fret_distance)
    |> Kernel.*(Keyword.get(options, :move, 1))
  end

  defp finger_distance(
         from,
         to,
         options
       ) do
    lift =
      from
      |> Enum.reject(&Enum.member?(to, &1))
      |> Enum.map(fn _ -> Keyword.get(options, :lift_bar, 1) end)
      |> Enum.sum()

    place =
      to
      |> Enum.reject(&Enum.member?(from, &1))
      |> Enum.map(fn _ -> Keyword.get(options, :place_bar, 1) end)
      |> Enum.sum()

    lift + place
  end
end
