#! /usr/bin/env elixir

IO.inspect(
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.chunk_every(3, 1, :discard)
  |> Enum.map(&Enum.sum/1)
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.filter(fn [x, y] -> x < y end)
  |> Enum.count())
