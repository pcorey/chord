defmodule Chord.Util do
  def attach_strings(chord),
    do:
      chord
      |> Enum.with_index()
      |> Enum.map(fn
        {{fret, finger}, string} -> {fret, finger, string}
        {nil, string} -> {nil, nil, string}
      end)
end
