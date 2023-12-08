#! /usr/bin/env elixir

defmodule Mat do
  def transp([[] | _]), do: []
  def transp(m), do: [Enum.map(m, &hd/1) | transp(Enum.map(m, &tl/1))]
end

count_while_smaller = fn list, x ->
  case Enum.find_index(list, fn n -> n >= x end) do
    nil -> Enum.count(list)
    n -> n+1
  end
end

get_line_score = fn list, i ->
  {l, [x | r]} = Enum.split(list, i)
  count_while_smaller.(Enum.reverse(l), x) * count_while_smaller.(r, x)
end

get_score = fn map ->
  map_x = Enum.count(map |> Enum.at(0))
  map
  |> Enum.slice(1..-2//1)
  |> Enum.map(fn l -> (1 .. (map_x - 2)) |> Enum.map(fn i -> get_line_score.(l, i) end) end)
end

map =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(fn x -> String.split(x, "", trim: true) |> Enum.map(&String.to_integer/1) end)

res =
  Enum.zip(
    get_score.(map) |> List.flatten(),
    Mat.transp(get_score.(Mat.transp(map))) |> List.flatten())
  |> Enum.map(fn {i, j} -> i * j end)
  |> Enum.max()

# assume the map is square
IO.inspect(res)
