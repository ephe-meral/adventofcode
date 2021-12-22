#! /usr/bin/env elixir

depths =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

depths_triplet =
  Enum.zip([
    depths,
    Enum.drop([nil | depths], -1),
    Enum.drop([nil, nil | depths], -2)])
  |> Enum.drop(2)
  |> Enum.map(fn {a, b, c} -> (a+b+c) end)

result =
  Enum.zip(
    depths_triplet,
    Enum.drop([nil | depths_triplet], -1))
  |> Enum.drop(1)
  |> Enum.map(fn {a, b} -> ((b-a) < 0) && 1 || 0 end)
  |> Enum.sum()

IO.inspect(result)
