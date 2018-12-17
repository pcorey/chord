:rand.seed(:exsplus, {0, 0, 0})
data = Enum.scan(0..10000, fn _, acc -> Enum.max([0, acc + :rand.uniform() - 0.5]) end)

:rand.seed(:exsplus, :os.timestamp())

# http://www.cleveralgorithms.com/nature-inspired/physical/simulated_annealing.html

neighbor = fn s_current ->
  [Enum.max([0, s_current - 1]), Enum.min([length(data) - 1, s_current + 1])]
  |> Enum.shuffle()
  |> Enum.at(0)
end

temperature = fn i -> 1 - i * 0.0000001 end

cost = fn s -> -Enum.at(data, s) end

initial =
  0..10000
  |> Enum.shuffle()
  |> Enum.at(0)

stream =
  Stream.unfold({initial, initial, 0}, fn {s_current, s_best, i} ->
    s_i = neighbor.(s_current)
    t = temperature.(i)

    if cost.(s_i) <= cost.(s_current) do
      if cost.(s_i) <= cost.(s_best) do
        {s_i, {s_i, s_i, i + 1}}
      else
        {s_best, {s_i, s_best, i + 1}}
      end
    else
      if :math.exp((cost.(s_current) - cost.(s_i)) / t) > :rand.uniform() do
        {s_best, {s_i, s_best, i + 1}}
      else
        {s_best, {s_current, s_best, i + 1}}
      end
    end
  end)

simulated_best =
  stream
  |> Enum.at(100_000)
  |> (&Enum.at(data, &1)).()

IO.puts("Simulated max: #{inspect(simulated_best)}")
IO.puts("Actual max: #{inspect(Enum.max(data))}")
