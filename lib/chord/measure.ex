defprotocol Chord.Measure do
  # @callback measure(Chord) :: float
  # @callback extensions() :: [String.t]
  # def measure(chord, options \\ [])
  # def measure(chord_a, chord_b, options \\ [])
end
