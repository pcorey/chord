# Chord

**This is very much a one-off experiment. Enjoy as is with no guarantees of correctness or usefulness.**

This project includes tools to generate all possibilities of a given chord
across a guitar's fretboard, render chord charts with unicode, and calculate the
"distance" between chords, which can be used to discover interesting voice
leading possibilities.

Let's start by generating all possible Cmaj7 chords:

```elixir
Chord.voicings([0, 4, 7, 11])
```

The numbers here refer to the mod 12 of the notes we want in our chord. In our
case, we want a C (`0`), E (`4`), G (`7`), and a B (`11`).

The `Chord.voicings/1` will impose some restrictions on the chords generated to
keep things a little more manageable. Currently, it only looks for chord shapes
in the first 12 frets, and rejects chords with a stretch greater than five
frets. It's also looking for chords on a six stringed, standard tuned guitar.
All of these restrictions and assumptions can be changed in the `Chord` module.

Once we have all of our possible voicings, we can render one as a chord chart:

```elixir
[0, 4, 7, 11]
|> Chord.voicings()
|> List.first()
|> Chord.to_string()
|> IO.puts()
```

```
 0 ●┬┬●●┬
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │●││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │││││●
```

We can also put a label on the chord by passing an optional second parameter to
`Chord.to_string/2`:

```elixir
|> Chord.to_string("Cmaj7")
```

```
 0 ●┬┬●●┬ Cmaj7
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │●││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │││││●
```

You can also use the `Chord.Note.to_integer/1` function to provide notes in the
standard notation:

```
Chord.Note.to_integer(["C", "Db", "D", "Eb"])
|> Chord.voicings()
|> List.first()
|> Chord.to_string()
|> IO.puts()
```

```
 0 ┬┬●┬┬┬
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │●││││
   ├┼┼┼┼┤
   ││││●│
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │││●││
```

We can also take all (`4` note versions) of our Cmaj7 voicings, calculate their
"semitone distances" from another chord, like a G7 (`[nil, 10, 12, 10, 12,
nil]`), and render the three voicings with the shortest distance. These chords
will, in theory, have nice voice leading between our G7 chord:

```elixir
[0, 4, 7, 11]
|> Chord.voicings(4)
|> Enum.map(&{Chord.Distance.Semitone.distance(&1, [nil, 10, 12, 10, 12, nil]), &1})
|> Enum.sort()
|> Enum.take(3)
|> Enum.map(fn {distance, chord} -> Chord.to_string(chord, "Cmaj7") end)
|> Enum.join("\n\n")
|> IO.puts()
```

```
 9 │││●││ Cmaj7
   ├┼┼┼┼┤
   │●●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│


 7 │││││● Cmaj7
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │││●││
   ├┼┼┼┼┤
   │●●│││


 5 ││●●●│ Cmaj7
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   │││││●
   ├┼┼┼┼┤
   ││││││
```

Try it out.

This is great, but it doesn't take _playability_ into account. We want nice
voice leading between chords, but we also want the transitions to be easy to
play for us, the guitar player!

We can generate all "possible" (for some values of "possible") fingerings for a
given guitar chord using `Chord.fingerings/1`:

```elixir
[nil, 10, 10, 9, 12, nil]
|> Chord.fingerings()
|> Enum.map(&Chord.to_string/1)
|> Enum.join("\n\n")
|> IO.puts()
```

```
 9 │││●││
   ├┼┼┼┼┤
   │●●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│
    2213

 9 │││●││
   ├┼┼┼┼┤
   │●●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│
    2214

 9 │││●││
   ├┼┼┼┼┤
   │●●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│
    2314
    
    
...
```

We can also compare the "distance" between fingerings. Let's compare the
distance between the normal fingering of our G7 chord with the third fingering
suggested for our Cmaj7:

```elixir
Chord.Distance.Fingering.distance(
  [nil, {10, 1}, {12, 3}, {10, 1}, {12, 4}, nil],
  [nil, {10, 2}, {10, 3}, {9, 1}, {12, 4}, nil]
)

```

This gives us a distance of `3`. This fingering distance is calculated using a
modified and weighted levenshtein distance where placing and lifting a finger
both cost `1` unit of distance, sliding a finger to any other fret on the same
string costs `1` unit of distance, and moving a finger to another string and
fret costs the "manhattan distance" of that move.

We can combine "semitone distance" and "fingering distance" to find the Cmaj7
chords that offers the best voice leading from our G7 chord, while still being
the "easiest" to play:

```elixir
[0, 4, 7, 11]
|> Chord.voicings(4)
|> Enum.map(&{Chord.Distance.Semitone.distance(&1, [nil, 10, 12, 10, 12, nil]), &1})
|> Enum.uniq()
|> Enum.sort()
|> Enum.chunk_by(&elem(&1, 0))
|> List.first()
|> Enum.map(&elem(&1, 1))
|> Enum.map(fn chord ->
  chord
  |> Chord.fingerings()
  |> Enum.uniq()
  |> Enum.map(
    &{Chord.Distance.Fingering.distance(&1, [nil, {10, 1}, {12, 3}, {10, 1}, {12, 4}, nil]), &1}
  )
end)
|> List.flatten()
|> Enum.sort()
|> Enum.chunk_by(&elem(&1, 0))
|> List.first()
|> Enum.map(&elem(&1, 1))
|> Enum.map(&Chord.to_string/1)
|> Enum.join("\n\n")
|> IO.puts()

```

```
 9 │││●││
   ├┼┼┼┼┤
   │●●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│
    2214

 9 │││●││
   ├┼┼┼┼┤
   │●●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│
    2314

...
```

Cool stuff.
