#! /usr/bin/env elixir

height_map =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.split(&1, "", trim: true))
  |> Enum.map(fn x -> [9] ++ Enum.map(x, &String.to_integer/1) ++ [9] end)

pad = List.duplicate(9, Enum.count(Enum.at(height_map,0)))
height_map = [pad] ++ height_map ++ [pad]

get_all_pos = fn x ->
  rows =
    Enum.with_index(height_map)
    |> Enum.filter(&Enum.any?(elem(&1, 0), fn y -> y==x end))
    |> Enum.map(fn {_, row} -> row end)
  Enum.flat_map(rows, fn row ->
    Enum.with_index(Enum.at(height_map, row))
    |> Enum.filter(fn {y, _} -> y==x end)
    |> Enum.map(fn {_, col} -> {row, col} end) end)
end

hm_at = fn x, y -> Enum.at(height_map, x) |> Enum.at(y) end

is_low_point = fn {x, y} ->
  hm_at.(x, y) < hm_at.(x-1, y) and
  hm_at.(x, y) < hm_at.(x+1, y) and
  hm_at.(x, y) < hm_at.(x, y-1) and
  hm_at.(x, y) < hm_at.(x, y+1)
end

res =
  Enum.reduce(0..8, 0, fn x, acc ->
    acc + (get_all_pos.(x)
     |> Enum.filter(&is_low_point.(&1))
     |> Enum.map(fn {x, y} -> hm_at.(x, y) + 1 end)
     |> Enum.sum())
  end)

IO.inspect(res)
