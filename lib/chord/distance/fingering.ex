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
    # IO.puts("noop")
    Keyword.get(options, :noop, 0)
  end

  # Place
  defp finger_distance([], [note], options) do
    # IO.puts("place #{inspect(note)}")
    Keyword.get(options, :place, 1)
  end

  # Lift
  defp finger_distance([note], [], options) do
    # IO.puts("lift #{inspect(note)}")
    Keyword.get(options, :lift, 1)
  end

  # Slide
  defp finger_distance(
         [note_a = {fret_a, finger, string}],
         [note_b = {fret_b, finger, string}],
         options
       ) do
    # IO.puts("slide #{inspect(note_a)} #{inspect(note_b)}")

    abs(fret_a - fret_b)
    |> Kernel.*(Keyword.get(options, :move_fret, 1))

    # |> Kernel.*(Keyword.get(options, :move, 1))
  end

  # Move
  defp finger_distance(
         [note_a = {fret_a, finger, string_a}],
         [note_b = {fret_b, finger, string_b}],
         options
       ) do
    # IO.puts("move #{inspect(note_a)} #{inspect(note_b)}")
    string_distance = abs(string_a - string_b) * Keyword.get(options, :move_string, 1)
    fret_distance = abs(fret_a - fret_b) * Keyword.get(options, :move_fret, 1)

    string_distance + fret_distance
    # |> Kernel.*(Keyword.get(options, :move, 1))
  end

  defp finger_distance(
         from,
         to,
         options
       ) do
    lift =
      from
      |> Enum.reject(fn {fret, finger, string} ->
        # We're lifting a bar if the finger isn't being played on the string anymore. If the finger is being played on the same stirng, but a different fret, we've slid the bar.
        to
        |> Enum.map(fn {fret, finger, string} -> {finger, string} end)
        |> Enum.member?({finger, string})
      end)
      # |> Enum.map(fn note -> IO.puts("lift bar #{inspect(note)}") end)
      |> Enum.map(fn _ -> Keyword.get(options, :lift_bar, 1) end)
      |> Enum.sum()

    place =
      to
      |> Enum.reject(&Enum.member?(from, &1))
      |> Enum.reject(fn {fret, finger, string} ->
        # We're placing a bar if the finger hasn't been played on the string. If the finger has been played on the string, but a different fret, we've slid the bar.
        from
        |> Enum.map(fn {fret, finger, string} -> {finger, string} end)
        |> Enum.member?({finger, string})
      end)
      # |> Enum.map(fn note -> IO.puts("place bar #{inspect(note)}") end)
      |> Enum.map(fn _ -> Keyword.get(options, :place_bar, 1) end)
      |> Enum.sum()

    # TODO: do this...
    slide =
      to
      |> Enum.reject(&Enum.member?(from, &1))
      |> Enum.reject(fn {fret, finger, string} ->
        # We're placing a bar if the finger hasn't been played on the string. If the finger has been played on the string, but a different fret, we've slid the bar.
        from
        |> Enum.map(fn {fret, finger, string} -> {finger, string} end)
        |> Enum.member?({finger, string})
      end)
      # |> Enum.map(fn note -> IO.puts("place bar #{inspect(note)}") end)
      |> Enum.map(fn _ -> Keyword.get(options, :place_bar, 1) end)
      |> Enum.sum()

    lift + place
  end
end
