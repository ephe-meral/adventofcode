#! /usr/bin/env elixir

positions =
  File.read!("input.txt")
  |> String.trim()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

sum = fn n -> round((n**2 + n) / 2) end # factorial, but with sums - sumtorial?
score = fn pos -> positions |> Enum.map(fn x -> sum.(abs(pos-x)) end) |> Enum.sum() end

# Turns out value function is pretty smooth. Arithm avg gets us very close to the answer.
avg = round(Enum.sum(positions) / Enum.count(positions))
max_search_radius = 100
# With that we do a super simple area search.
res =
  (avg-max_search_radius)..(avg+max_search_radius)
  |> Enum.map(&score.(&1))
  |> Enum.sort()
  |> Enum.at(0)

IO.inspect(res)
