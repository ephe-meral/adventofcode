#! /usr/bin/env elixir

items = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.to_charlist()

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.split_at(x, round(String.length(x)/2)) end)
  |> Enum.map(fn {l, r} -> {String.to_charlist(l), String.to_charlist(r)} end)
  |> Enum.map(fn {l, r} -> MapSet.intersection(MapSet.new(l), MapSet.new(r)) end)
  |> Enum.map(fn x -> Enum.at(Enum.into(x, []), 0) end)
  |> Enum.map(fn x -> Enum.find_index(items, fn y -> x==y end)+1 end) # 1-based index
  |> Enum.sum()

IO.inspect(res)
