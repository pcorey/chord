# Chord

**This is very much a one-off experiment. Enjoy as is with no guarantees of correctness or usefulness.**

This project includes tools to generate all possibilities of a given chord across a guitar's fretboard, render chord charts with unicode, and calculate the "distance" between chords, which can be used to discover interesting voice leading possibilities.

Let's start by generating all possible Cmaj7 chords:

```elixir
Chord.voicings([0, 4, 7, 11])
```

The numbers here refer to the mod 12 of the notes we want in our chord. In our case, we want a C (`0`), E (`4`), G (`7`), and a B (`11`). 

The `Chord.voicings/1` will impose some restrictions on the chords generated to keep things a little more manageable. Currently, it only looks for chord shapes in the first 12 frets, and rejects chords with a stretch greater than five frets. It's also looking for chords on a six stringed, standard tuned guitar. All of these restrictions and assumptions can be changed in the `Chord` module.

Once we have all of our possible voicings, we can render one as a chord chart:

```elixir
[0, 4, 7, 11]
|> Chord.voicings()
|> List.first()
|> Chord.to_string()
|> IO.puts()
```

```
 0 ││││●●
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ●●││││
   ├┼┼┼┼┤
   │││●││
   ├┼┼┼┼┤
   ││●│││
```

We can also put a label on the chord by passing an optional second parameter to `Chord.to_string/2`:

```elixir
|> Chord.to_string("Cmaj7")
```

```
 0 ││││●● Cmaj7
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ●●││││
   ├┼┼┼┼┤
   │││●││
   ├┼┼┼┼┤
   ││●│││
```

We can also take all of our Cmaj7 voicings, calculate their distances from another chord, like a G7 (`[nil, 10, 12, 10, 12, nil]`), and render the three voicings with the shortest distance. These chords will have nice voice leading between our G7 chord:

```elixir
[0, 4, 7, 11]
|> Chord.voicings()
|> Enum.map(&{Chord.distance(&1, [nil, 10, 12, 10, 12, nil]), &1})
|> Enum.sort()
|> Enum.take(3)
|> Enum.map(fn {distance, chord} -> Chord.to_string(chord, "Cmaj7") end)
|> Enum.join("\n\n")
|> IO.puts()
```

```
 8 ●│││││ Cmaj7
   ├┼┼┼┼┤
   │││●││
   ├┼┼┼┼┤
   │●││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│

 9 │││●││ Cmaj7
   ├┼┼┼┼┤
   │●●│││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│

 8 │││││● Cmaj7
   ├┼┼┼┼┤
   │││●││
   ├┼┼┼┼┤
   │●││││
   ├┼┼┼┼┤
   ││││││
   ├┼┼┼┼┤
   ││││●│
```

Try it out.

One unit of distance is added for every semitone moved per string between chords, and for every string that is added or removed.
