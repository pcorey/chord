import Inversions

[1, 2, 3, 4, 5]
|> inversions()
|> IO.inspect()

[1, 3, 3, 4, 5]
|> inversions()
|> IO.inspect()

[1, 3, 2, 4, 5]
|> inversions()
|> IO.inspect()

[9, 3, 2, 4, 5]
|> inversions()
|> IO.inspect()

[5, 4, 3, 2, 1]
|> inversions()
|> IO.inspect()

IO.puts("~~~")

[1, 2, 3, 4, 5]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()

[1, 2, 3, 5, 4]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()

[1, 2, 5, 4, 3]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()

[1, 3, 2, 5, 4]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()

[1, 4, 3, 5, 2]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()

[4, 1, 2, 3, 5]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()

[4, 2, 5, 3, 1]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()

[5, 4, 3, 2, 1]
|> inversions([1, 2, 3, 4, 5])
|> IO.inspect()
