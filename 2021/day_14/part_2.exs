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
    {[a, b], [[a, ins], [ins, b]]}
  end)
  |> Map.new()

init_counts =
  init
  |> Enum.chunk_every(2, 1, :discard)
  |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)

polymerize = fn counts ->
  counts |> Enum.reduce(%{}, fn {pair, count}, acc ->
    [p1, p2] = Map.get(rules, pair)
    Map.update(acc, p1, count, &(&1 + count))
    |> Map.update(p2, count, &(&1 + count))
  end)
end

score = fn counts ->
  {min_el, max_el} =
    counts
    |> Map.to_list()
    |> Enum.reduce([%{}, %{}], fn {[a, b], count}, [as, bs] ->
      as = Map.update(as, a, count, &(&1 + count))
      bs = Map.update(bs, b, count, &(&1 + count))
      [as, bs]
    end)
    |> (fn [as, bs] ->
      Map.merge(as, bs, fn _k, a, b -> max(a, b) end)
    end).()
    |> Map.values()
    |> Enum.min_max()
  max_el - min_el
end

steps = 40

res =
  Enum.reduce(1..steps, init_counts, fn _, p -> polymerize.(p) end)
  |> score.()

IO.inspect(res)
