#! /usr/bin/env elixir

defmodule Mat do
  def transp([[] | _]), do: []
  def transp(m), do: [Enum.map(m, &hd/1) | transp(Enum.map(m, &tl/1))]
end

is_visible = fn list, i ->
  {l, [x | r]} = Enum.split(list, i)
  (Enum.max(l) < x) || (Enum.max(r) < x)
end

visibility_lines = fn map ->
  map_x = Enum.count(map |> Enum.at(0))
  map
  |> Enum.slice(1..-2//1)
  |> Enum.map(fn l -> (1 .. (map_x - 2)) |> Enum.map(fn i -> is_visible.(l, i) end) end)
end

map =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.map(&String.to_integer/1) end)

res =
  Enum.zip(
    visibility_lines.(map) |> List.flatten(),
    Mat.transp(visibility_lines.(Mat.transp(map))) |> List.flatten())
  |> Enum.filter(fn {i, j} -> !i && !j end)
  |> Enum.count()

# assume the map is square
IO.inspect(Enum.count(map)**2 - res)
