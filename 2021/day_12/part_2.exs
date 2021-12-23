#! /usr/bin/env elixir

edge_dict =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "-"))
  |> Enum.reduce(%{}, fn [a, b], acc ->
    acc = (b=="start" or a=="end") && acc || Map.update(acc, a, [b], fn exst -> Enum.uniq([b | exst]) end)
    (a=="start" or b=="end") && acc || Map.update(acc, b, [a], fn exst -> Enum.uniq([a | exst]) end)
  end)


defmodule Paths do
  def gen_all(edge_dict), do: gen_all(edge_dict, [], "start", 100)
  def gen_all(_edge_dict, acc, vert, 0), do: [[vert | acc]]
  def gen_all(_edge_dict, acc, "end", _), do: [["end" | acc]]
  def gen_all(edge_dict, acc, vert, max_length) do
    if lower_case_uniq_plus_on?([vert | acc]), do:
      Map.get(edge_dict, vert)
      |> Enum.flat_map(fn v -> gen_all(edge_dict, [vert | acc], v, max_length-1) end),
    else: []
  end

  def lower_case_uniq_plus_on?(path) do
    tmp = path |> Enum.filter(&lower_case?(&1))
    Enum.count(tmp) <= (Enum.count(Enum.uniq(tmp)) + 1)
  end

  def lower_case?(x), do: x != String.upcase(x)
end

IO.inspect(Enum.count(Paths.gen_all(edge_dict)))
