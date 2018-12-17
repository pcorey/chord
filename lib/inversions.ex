# https://stackoverflow.com/a/16994740
# https://en.wikipedia.org/wiki/Inversion_(discrete_mathematics)

defmodule Inversions do
  import Factorial

  def inversions(list) do
    length = length(list)
    n_c_2 = factorial(length) / (2 * factorial(length - 2))

    for i <- 0..(length - 2), j <- (i + 1)..(length - 1) do
      {Enum.at(list, i), Enum.at(list, j)}
    end
    |> Enum.filter(fn {a, b} -> a > b end)
    |> length
    |> Kernel./(n_c_2)
  end

  def inversions(list, sorted) when length(list) == length(sorted) do
    length = length(sorted)
    n_c_2 = factorial(length) / (2 * factorial(length - 2))

    for i <- 0..(length - 1), j <- i..(length - 1) do
      {i, j}
    end
    |> Enum.filter(fn {a, b} ->
      Enum.at(list, a) > Enum.at(sorted, b)
    end)
    |> length
    |> Kernel./(n_c_2)
  end
end
