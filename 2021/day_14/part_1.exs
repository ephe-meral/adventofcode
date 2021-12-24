#! /usr/bin/env elixir

[head | tail] =
  File.read!("input.txt")
  |> String.split("\n", trim: true)

init = head |> String.split("", trim: true)

rules =
  tail
  |> Enum.map(&String.split(&1, " -> "))
  |> Enum.map(fn [pat, ins] ->
    [a, b] = String.split(pat, "", trim: true)
    {[a, b], [a, ins]}
  end)
  |> Map.new()

polymerize = fn state ->
  state
  |> Enum.chunk_every(2, 1)
  |> Enum.flat_map(&Map.get(rules, &1, &1))
end

steps = 10

{min_el, max_el} =
  Enum.reduce(1..steps, init, fn _, p -> polymerize.(p) end)
  |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  |> Map.values()
  |> Enum.min_max()

IO.inspect(max_el - min_el)
