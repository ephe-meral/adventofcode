#! /usr/bin/env elixir

res =
  File.read!("input.txt")
  |> String.split(~r/^$/m, trim: true)
  |> Enum.map(fn x -> String.split(x, "\n", trim: true) end)
  |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
  |> Enum.map(&Enum.sum/1)
  |> Enum.sort(:desc)

IO.inspect(Enum.at(res, 0))
IO.inspect(Enum.sum(Enum.slice(res, 0, 3)))
