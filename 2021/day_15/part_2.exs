#! /usr/bin/env elixir

risk_map =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.split(&1, "", trim: true))
  |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)

count_x = Enum.count(risk_map)
count_y = Enum.count(Enum.at(risk_map, -1))

# Enlarge risk map
risk_map =
  for x <- 0..(count_x*5-1), y <- 0..(count_y*5-1) do
    orig_r = (risk_map |> Enum.at(rem(x, count_x)) |> Enum.at(rem(y, count_y))) - 1
    add = floor(x/count_x) + floor(y/count_y)
    rem(orig_r + add, 9) + 1
  end
  |> Enum.chunk_every(count_y*5)

get_risk = fn {x, y} -> risk_map |> Enum.at(x) |> Enum.at(y) end

start_p = %{{0,0} => {[{0,0}], 0}} # risk only counted on 'enter'
end_p = {Enum.count(risk_map)-1, Enum.count(Enum.at(risk_map, -1))-1}

IO.inspect(end_p)

adj_paths = fn {[{x, y} | _] = path, risk} ->
  [{x-1, y}, {x+1, y}, {x, y-1}, {x, y+1}]
  |> Enum.filter(fn {x, y} ->
    (x >= 0) and (y >= 0) and (x <= elem(end_p, 0)) and (y <= elem(end_p, 1))
  end)
  |> Enum.map(fn p -> {p, {[p | path], risk + get_risk.(p)}} end)
  |> Enum.into(%{})
end

paths = Map.merge(start_p, adj_paths.(start_p[{0,0}]))

max_iter = 100_000

res =
  Enum.reduce_while(1..max_iter, {start_p, paths}, fn i, {last_ps, ps} ->
    case (Map.keys(ps) -- Map.keys(last_ps)) do
      []     ->
        IO.puts("Halting after #{i} iterations.")
        {:halt, ps}
      new_ps ->
        (rem(i, 10) == 0) && IO.write(".")
        (rem(i, 100) == 0) && IO.write(inspect(Enum.at(Map.keys(ps) -- Map.keys(last_ps), 0)))
        {:cont, {ps,
          new_ps
          |> Enum.map(&Map.get(ps, &1))
          |> Enum.reduce(ps, fn p, acc ->
            Map.merge(acc, adj_paths.(p), fn
              _k, {_, r1}, {_, r2} = p2 when r1 > r2 -> p2
              _, p1, _                               -> p1
            end)
          end)}
        }
    end
  end)

# NB: Delivers the correct map afaict and the correct result for the smaller
# variant (315 for test2)
# However, delivers a value that is too high for the real data (3001)
IO.inspect(elem(res[end_p], 1))
