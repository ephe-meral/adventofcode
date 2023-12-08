#! /usr/bin/env elixir

items = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.to_charlist()

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.chunk_every(3)
  |> Enum.map(fn x -> Enum.map(x, &String.to_charlist/1) end)
  |> Enum.map(fn x -> Enum.map(x, &MapSet.new/1) end)
  |> Enum.map(fn x -> Enum.reduce(x, &MapSet.intersection/2) end)
  |> Enum.map(fn x -> Enum.at(Enum.into(x, []), 0) end)
  |> Enum.map(fn x -> Enum.find_index(items, fn y -> x==y end)+1 end) # 1-based index
  |> Enum.sum()

IO.inspect(res)
