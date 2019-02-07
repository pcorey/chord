root = 0
quality = [4, 3, 4, 1]
gaps = [1, 0, 1]

gap_map =
  gaps
  |> Enum.map(&([true] ++ List.duplicate(false, &1)))
  |> Kernel.++([true])
  |> List.flatten()
  |> IO.inspect()

[0]
|> Stream.concat(Stream.cycle([4, 3, 4, 1]))
|> Stream.scan(&Kernel.+/2)
|> Stream.map(&(root + &1))
|> Stream.zip(Stream.cycle(gap_map))
|> Stream.filter(&elem(&1, 1))
|> Stream.map(&elem(&1, 0))
|> Stream.take(10)
|> Enum.to_list()
|> IO.inspect()
