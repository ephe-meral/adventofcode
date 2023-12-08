#! /usr/bin/env elixir

map_update = fn state, dir, i ->
  (0 .. Enum.count(dir))
  |> Enum.map(fn i -> Enum.take(dir, -i) end)
  |> Enum.reduce(state, fn d, s -> Map.update(s, d, i, fn x -> x+i end) end)
end

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.drop(1)
  |> Enum.reduce({[], %{}}, fn l, {dir, state} ->
    case String.split(l, " ", trim: true) do
      ["$", "cd", ".."] -> {tl(dir), state}
      ["$", "cd", d] -> {[d | dir], state}
      [h | _] ->
        case Integer.parse(h) do
          {i, _} -> {dir, map_update.(state, dir, i)}
          _ -> {dir, state}
        end
    end
  end)
  |> elem(1)
  |> Map.values()

res1 =
  res
  |> Enum.filter(fn x -> x <= 100_000 end)
  |> Enum.sum()

res2 =
  res
  |> Enum.filter(fn x -> x >= (30_000_000 - (70_000_000 - Enum.max(res))) end)
  |> Enum.min()

IO.inspect(res1)
IO.inspect(res2)
