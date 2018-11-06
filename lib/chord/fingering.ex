defmodule Chord.Fingering do
  def fingerings(chord),
    do:
      chord
      |> attach_possible_fingers()
      |> choose_and_sieve()
      |> cleanup()

  defp attach_possible_fingers(chord),
    do: Enum.map(chord, &{&1, 1..4})

  defp cleanup(fingerings),
    do:
      Enum.map(fingerings, fn fingering ->
        fingering
        |> Tuple.to_list()
        |> Enum.map(fn
          {nil, nil} -> nil
          string -> string
        end)
      end)

  defp choose_and_sieve(chord, fingerings \\ [])

  defp choose_and_sieve([], fingerings),
    do: [
      fingerings
      |> Enum.reverse()
      |> List.to_tuple()
    ]

  defp choose_and_sieve([{nil, _possible_fingers} | chord], fingerings),
    do: [choose_and_sieve(chord, [{nil, nil} | fingerings])] |> List.flatten()

  defp choose_and_sieve([{0, _possible_fingers} | chord], fingerings),
    do: [choose_and_sieve(chord, [{0, nil} | fingerings])] |> List.flatten()

  defp choose_and_sieve([{fret, possible_fingers} | chord], fingerings),
    do:
      possible_fingers
      |> Enum.map(fn finger ->
        new_fingerings = [{fret, finger} | fingerings]

        chord
        |> sieve_chord(new_fingerings)
        |> choose_and_sieve(new_fingerings)
        |> List.flatten()
      end)
      |> List.flatten()

  defp sieve_chord(chord, fingerings),
    do:
      chord
      |> Enum.map(fn {fret, possible_fingers} ->
        {fret, sieve_fingers(possible_fingers, fret, fingerings)}
      end)

  defp sieve_fingers(possible_fingers, fret, fingerings),
    do: Enum.reject(possible_fingers, &bad_finger?(fret, &1, fingerings))

  defp bad_finger?(fret, finger, fingerings),
    do:
      Enum.any?([
        fret_above_finger_below?(fret, finger, fingerings),
        fret_below_finger_above?(fret, finger, fingerings),
        same_finger?(fret, finger, fingerings),
        impossible_bar?(fret, finger, fingerings)
      ])

  defp fret_above_finger_below?(fret, finger, [{new_fret, new_finger} | _]),
    do: fret > new_fret && finger < new_finger

  defp fret_below_finger_above?(fret, finger, [{new_fret, new_finger} | _]),
    do: fret < new_fret && finger > new_finger

  defp same_finger?(fret, finger, [{new_fret, new_finger} | _]),
    do: finger == new_finger && fret != new_fret

  defp impossible_bar?(_fret, finger, fingerings = [{new_fret, _} | _]),
    do:
      fingerings
      |> Enum.filter(fn {fret, _finger} -> fret > new_fret end)
      |> Enum.map(fn {_fret, finger} -> finger end)
      |> Enum.member?(finger)
end
