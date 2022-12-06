#! /usr/bin/env elixir

input =
  File.read!("input.txt")
  |> String.split("\n", trim: true)

# lazy solution (loose=0, draw=3, win=6)
lookup_1 = %{
  "A X" => [1, 3],
  "A Y" => [2, 6],
  "A Z" => [3, 0],
  "B X" => [1, 0],
  "B Y" => [2, 3],
  "B Z" => [3, 6],
  "C X" => [1, 6],
  "C Y" => [2, 0],
  "C Z" => [3, 3]
}

res_1 =
  input
  |> Enum.map(fn x -> Enum.sum(Map.get(lookup_1, x)) end)
  |> Enum.sum()

IO.inspect(res_1)

# lazy solution, part 2 (X=loose, Y=draw, Z=win)
lookup_2 = %{
  "A X" => [3, 0],
  "A Y" => [1, 3],
  "A Z" => [2, 6],
  "B X" => [1, 0],
  "B Y" => [2, 3],
  "B Z" => [3, 6],
  "C X" => [2, 0],
  "C Y" => [3, 3],
  "C Z" => [1, 6]
}

res_2 =
  input
  |> Enum.map(fn x -> Enum.sum(Map.get(lookup_2, x)) end)
  |> Enum.sum()

IO.inspect(res_2)
