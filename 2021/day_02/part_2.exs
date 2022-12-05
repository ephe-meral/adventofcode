#! /usr/bin/env elixir

start = {0, 0, 0} # aim (i.e. slope), x, y

{_end_aim, end_x, end_y} =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.split(x, " ") end)
  |> Enum.map(fn [a, b] -> [a, String.to_integer(b)] end)
  |> Enum.map(fn
      ["forward", dx] -> {0, dx}
      ["down", da]    -> {da, 0}
      ["up", da]      -> {-da, 0} end)
  |> Enum.reduce(start, fn {da, dx}, {a, x, y} -> {a+da, x+dx, y+(dx*a)} end)

IO.inspect(end_x * end_y)
