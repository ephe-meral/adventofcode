#! /usr/bin/env elixir

positions =
  File.read!("input.txt")
  |> String.trim()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

med = Enum.at(Enum.sort(positions), round(Enum.count(positions)/2))

res = positions |> Enum.map(fn x -> abs(med-x) end) |> Enum.sum()

IO.puts(res)
