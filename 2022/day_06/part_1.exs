#! /usr/bin/env elixir

res =
  File.read!("input.txt")
  |> String.split("", trim: true)
  |> Enum.chunk_every(4, 1)
  |> Enum.find_index(fn [a, b, c, d] ->
    (a != b) && (a != c) && (a != d) && (b != c) && (b != d) && (c != d)
  end)

IO.inspect(res + 4) # length of chunk
