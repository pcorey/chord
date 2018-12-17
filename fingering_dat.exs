from = [nil, {3, 1}, {5, 3}, {5, 3}, {5, 3}, nil]
to = [nil, {5, 1}, {7, 3}, {6, 2}, {7, 4}, nil]

# Chord.Distance.Fingering.distance(from, to)
# |> IO.inspect()

max = 100

for y <- 0..max, x <- 0..max do
  IO.puts(
    "#{x / max} #{y / max} #{
      Chord.Distance.Fingering.distance(from, to, move_fret: x / max, move_string: y / max)
    }"
  )
end
