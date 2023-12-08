#! /usr/bin/env elixir

# stack configuration, initially (lazily hardcoded here)
#
#                         [Z] [W] [Z]
#         [D] [M]         [L] [P] [G]
#     [S] [N] [R]         [S] [F] [N]
#     [N] [J] [W]     [J] [F] [D] [F]
# [N] [H] [G] [J]     [H] [Q] [H] [P]
# [V] [J] [T] [F] [H] [Z] [R] [L] [M]
# [C] [M] [C] [D] [F] [T] [P] [S] [S]
# [S] [Z] [M] [T] [P] [C] [D] [C] [D]
#  1   2   3   4   5   6   7   8   9 

stacks = %{
  1 => ["N", "V", "C", "S"],
  2 => ["S", "N", "H", "J", "M", "Z"],
  3 => ["D", "N", "J", "G", "T", "C", "M"],
  4 => ["M", "R", "W", "J", "F", "D", "T"],
  5 => ["H", "F", "P"],
  6 => ["J", "H", "Z", "T", "C"],
  7 => ["Z", "L", "S", "F", "Q", "R", "P", "D"],
  8 => ["W", "P", "F", "D", "H", "L", "S", "C"],
  9 => ["Z", "G", "N", "F", "P", "M", "S", "D"]
}

move = fn stacks, times, from, to ->
  {val, stacks} = Map.get_and_update(stacks, from, fn st -> Enum.split(st, times) end)
  Map.update(stacks, to, [], fn t -> val ++ t end)
end

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.drop(9)
  |> Enum.map(fn x -> Regex.scan(~r/[^0-9]+([0-9]+)[^0-9]+([0-9]+)[^0-9]+([0-9]+).*/, x) end)
  |> Enum.map(fn [[_ | x]] -> Enum.map(x, &String.to_integer/1) end)
  |> Enum.reduce(stacks, fn [times, from, to], s -> move.(s, times, from, to) end)

res =
  (1 .. 9)
  |> Enum.map(fn x -> Map.get(res, x) |> Enum.at(0) end)
  |> Enum.join("")

IO.inspect(res)
