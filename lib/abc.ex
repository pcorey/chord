# http://abcnotation.com/wiki/abc:standard:v2.1#the_tune_body
# http://trillian.mit.edu/~jc/music/abc/doc/ABCtut_Chords.html#Gchords
# http://abcnotation.com/wiki/abc:standard:v2.1#music_code_definition

defmodule ABC do
  def parse(input) do
    input
    |> preprocess()
    |> process()
    |> (fn %{chords: chords} -> chords end).()
    |> IO.inspect()
    |> Enum.reduce(fn a, b ->
      IO.puts("'")
      IO.inspect(a)
      IO.inspect(b)
      b ++ [a]
    end)
    |> IO.inspect()
  end

  defp process(lines, result \\ %{chords: []})

  defp process([], result),
    do: result

  # defp process(["K:" <> line | rest], result),
  #   do: process(rest, ABC.Key.parse(line, result))

  defp process([<<_::binary-size(1), ":", _::binary>> | rest], result),
    do: process(rest, result)

  defp process([line | rest], result = %{chords: chords}) do
    process(rest, %{result | chords: [parse_line(line) ++ chords]})
  end

  defp parse_line(line) do
    line
    |> String.replace(~r/[|\(\)\[\] ]/, "")
    |> String.split("\"", trim: true)
    |> parse_chord_and_notes()
    |> Enum.reverse()
  end

  defp parse_chord_and_notes([]) do
    []
  end

  defp parse_chord_and_notes([chord]) do
    [ABC.Chord.parse(chord)]
  end

  defp parse_chord_and_notes([chord, notes | rest]) do
    base_chord = ABC.Chord.parse(chord)

    chords =
      notes
      |> ABC.Note.parse([0, 0, 0, 0, 0, 0, 0])
      |> Enum.map(fn note -> base_chord ++ [{:highest, note}] end)

    chords ++ parse_chord_and_notes(rest)
  end

  def preprocess(input) do
    input
    |> String.split("\n", trim: true)
    |> join_continuations()
    |> join_line_breaks()
    |> Enum.map(&strip_fat_bars/1)
    |> Enum.flat_map(&split_inline_fields/1)
  end

  def strip_fat_bars(line),
    do: String.replace(line, "|]", "|")

  def join_continuations([]),
    do: []

  def join_continuations([a, b = "+:" <> rest_b | rest]),
    do: join_continuations([a <> " " <> rest_b | rest])

  def join_continuations([a | rest]),
    do: [a] ++ join_continuations(rest)

  def join_line_breaks([]),
    do: []

  def join_line_breaks([a, b | rest]) do
    if String.ends_with?(a, "\\") do
      join_line_breaks([String.trim_trailing(a, "\\") <> b | rest])
    end
  end

  def join_line_breaks([a | rest]),
    do: [a | join_line_breaks(rest)]

  def split_inline_fields(line) do
    line
    |> String.split(~r/[\[\]]/, trim: true)
    |> Enum.map(&String.trim/1)
  end
end
