#! /usr/bin/env elixir

depths =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

result =
  Enum.zip(depths, Enum.drop([nil | depths], -1))
  |> Enum.drop(1)
  |> Enum.map(fn {a, b} -> ((b-a) < 0) && 1 || 0 end)
  |> Enum.sum()

IO.inspect(result)
