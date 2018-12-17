alias Chord.Measure.{Notes, Semitones, Invertedness, Playability}

import Chord

from = [nil, {3, 3}, {2, 2}, {0, nil}, {1, 1}, nil]

[0, 4, {:optional, 7}, 11]
# Generate all possible voicings:
|> voicings()
# `from` is passed as an options list into every measure MFA:
|> sort_by([Notes, [Semitones, Invertedness, Playability]], from: from)
