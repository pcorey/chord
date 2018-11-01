defmodule PermutationTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Permutation

  @max_length 5

  defp factorial(n) when n <= 0,
    do: 1

  defp factorial(n),
    do: n * factorial(n - 1)

  defp pnk(list, k),
    do: div(factorial(length(list)), factorial(length(list) - k))

  property "returns a list of lists" do
    check all list <- list_of(integer(), max_length: @max_length) do
      permutations = Permutation.generate(list)
      assert permutations |> is_list
      Enum.map(permutations, &assert(&1 |> is_list))
    end
  end

  property "returns the correct number of permutations" do
    check all list <- list_of(integer(), max_length: @max_length),
              k <- integer(0..length(list)) do
      assert pnk(list, k) ==
               list
               |> Permutation.generate(k)
               |> length
    end
  end

  property "permutations only include elements from list" do
    check all list <- list_of(integer(), max_length: @max_length),
              k <- integer(0..length(list)) do
      assert [] ==
               list
               |> Enum.with_index()
               |> Permutation.generate(k)
               |> Enum.reject(fn permutation ->
                 [] ==
                   permutation
                   |> Enum.reject(&Enum.member?(list |> Enum.with_index(), &1))
               end)
    end
  end
end
