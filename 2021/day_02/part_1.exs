#! /usr/bin/env elixir

start = {0, 0}

{end_x, end_y} =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.split(x, " ") end)
  |> Enum.map(fn [a, b] -> [a, String.to_integer(b)] end)
  |> Enum.map(fn
      ["forward", dx] -> {dx, 0}
      ["down", dy]    -> {0, dy}
      ["up", dy]      -> {0, -dy} end)
  |> Enum.reduce(start, fn {dx, dy}, {x, y} -> {x+dx, y+dy} end)

IO.inspect(end_x * end_y)
