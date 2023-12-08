#! /usr/bin/env elixir

comp_1 = fn [[x, y], [s, t]] ->
  (((x <= s) && (y >= t)) || ((s <= x) && (t >= y))) && 1 || 0
end

comp_2 = fn [[x, y], [s, t]] ->
  (((x <= s) && (y >= s)) || ((s <= x) && (t >= x))) && 1 || 0
end

tmp =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.split(x, ",", trim: true) end)
  |> Enum.map(fn x -> Enum.map(x, fn x ->
    String.split(x, "-", trim: true)
    |> Enum.map(&String.to_integer/1)
  end) end)

res_1 =
  tmp
  |> Enum.map(comp_1)
  |> Enum.sum()

res_2 =
  tmp
  |> Enum.map(comp_2)
  |> Enum.sum()

IO.inspect(res_1)
IO.inspect(res_2)
