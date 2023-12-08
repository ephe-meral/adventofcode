#! /usr/bin/env elixir

res =
  File.read!("input.txt")
  |> String.split("", trim: true)
  |> Enum.chunk_every(14, 1)
  |> Enum.find_index(fn x ->
    (MapSet.new(x) |> MapSet.size()) == 14
  end)

IO.inspect(res + 14) # length of chunk
