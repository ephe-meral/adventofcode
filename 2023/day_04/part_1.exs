#! /usr/bin/env elixir

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.replace(x, ~r/^Card \d+: /, "", trim: true) end)
  |> Enum.map(fn x -> String.split(x, "|", trim: true) end)
  |> Enum.map(fn x -> Enum.map(x, fn y -> String.split(y, " ", trim: true) end) end)
  |> Enum.map(fn [win, ours] -> MapSet.new(win) |> MapSet.intersection(MapSet.new(ours)) end)
  |> Enum.map(fn x -> MapSet.size(x) end)

res_1 =
  res
  |> Enum.map(fn x -> min(x, 1) * 2**(max(0, x-1)) end)
  |> Enum.sum()

copies = 0..(Enum.count(res)-1) |> Enum.map(fn x -> {x, 1} end) |> Map.new()
res_2 =
  res
  |> Enum.with_index(0)
  |> Enum.reduce(copies, fn {card_copying, i}, copies ->
    copies_added = Map.fetch!(copies, i)
    start_card = i+1
    if start_card > Enum.count(res)-1 or card_copying == 0 do
      copies
    else
      end_card = min(Enum.count(res)-1, (start_card+card_copying-1))
      start_card..end_card |> Enum.reduce(copies, fn j, acc ->
        Map.update!(acc, j, &(&1 + copies_added))
      end)
    end
  end)
  |> Map.values()
  |> Enum.sum()

IO.inspect(res)
IO.inspect(res_1)
IO.inspect(res_2)
