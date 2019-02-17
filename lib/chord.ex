defmodule Chord do
  defstruct root: nil,
            quality: nil,
            gaps: nil,
            strings: nil,
            chord: nil

  def all(frets \\ 12) do
    for root <- 0..0 do
      for quality <- [[4, 3, 4, 1]] do
        for gaps <- [[1, 0, 1]] do
          for strings <- [[nil, nil, 50, 55, 59, 64]] do
            Chord.Voicing.voicings(root, quality, gaps, strings, 12)
          end
          |> Enum.reduce(&Kernel.++/2)
        end
        |> Enum.reduce(&Kernel.++/2)
      end
      |> Enum.reduce(&Kernel.++/2)
    end
    |> Enum.reduce(&Kernel.++/2)
  end

  def to_string(chord, chord_name \\ nil),
    do: Chord.Renderer.to_string(chord, chord_name)

  def fingerings(chord),
    do: Chord.Fingering.fingerings(chord)

  def distance(chord_a, chord_b),
    do: Chord.Distance.distance(chord_a, chord_b)
end
