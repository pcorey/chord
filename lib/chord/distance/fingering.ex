# https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#Erlang
# https://nlp.stanford.edu/IR-book/html/htmledition/edit-distance-1.html

defmodule Chord.Distance.Fingering do
  def distance(chord, chord),
    do: 0

  def distance(chord_a = [{_, _} | _], chord_b),
    do: distance(attach_strings(chord_a), chord_b)

  def distance(chord_a, chord_b = [{_, _} | _]),
    do: distance(chord_a, attach_strings(chord_b))

  def distance(chord, []),
    do:
      chord
      |> Enum.reject(&(&1 == nil))
      |> length

  def distance([], chord),
    do:
      chord
      |> Enum.reject(&(&1 == nil))
      |> length

  def distance([note_a | rest_a] = chord_a, [note_b | rest_b] = chord_b),
    do:
      Enum.min([
        distance(rest_a, chord_b) + 1,
        distance(chord_a, rest_b) + 1,
        distance(rest_a, rest_b) + note_distance(note_a, note_b)
      ])

  defp attach_strings(chord),
    do:
      chord
      |> Enum.with_index()
      |> Enum.map(fn
        {{fret, finger}, string} -> {fret, finger, string}
        {nil, string} -> {nil, nil, string}
      end)

  def note_distance(note, note),
    do: 0

  # Place finger
  def note_distance(nil, _),
    do: 1

  # Lift finger
  def note_distance(_, nil),
    do: 1

  # Slide finger
  def note_distance({_, _, string}, {_, _, string}),
    do: 1

  # No-op
  def note_distance({nil, _, string_a}, {nil, _, string_b}),
    do: 0

  # Place finger
  def note_distance({nil, _, string_a}, {fret_b, _, string_b}),
    do: 1

  # Lift finger
  def note_distance({fret_a, _, string_a}, {nil, _, string_b}),
    do: 1

  # Move finger
  def note_distance({fret_a, _, string_a}, {fret_b, _, string_b}),
    do: abs(fret_a - fret_b) + abs(string_a - string_b)
end
