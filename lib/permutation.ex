defmodule Permutation do
  def generate(list, k \\ nil, repetitions \\ false)
  def generate([], _k, _repetitions), do: [[]]
  def generate(_list, 0, _repetitions), do: [[]]

  def generate(list, k, repetitions) do
    for head <- list,
        tail <- generate(next_list(list, head, repetitions), next_k(k)),
        do: [head | tail]
  end

  defp next_k(k) when is_number(k),
    do: k - 1

  defp next_k(k),
    do: k

  defp next_list(list, _head, true),
    do: list

  defp next_list(list, head, false),
    do: list -- [head]
end
