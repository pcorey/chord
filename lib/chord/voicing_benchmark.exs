@doc ~S"""
mix profile.fprof --callers=true --eval="Chord.Voicing.voicings([0, 4, 7, 11])"
"""

Benchee.run(
  %{
    "Chord.Voicing.voicings" => fn -> Chord.Voicing.voicings([0, 4, 7, 11]) end
  },
  time: 30
)
