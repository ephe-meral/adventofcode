#! /usr/bin/env elixir

timers =
  File.read!("input.txt")
  |> String.trim()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

# Naive approach: just do what they describe - see part 2 for a different version
time_step = fn ts -> Enum.flat_map(ts, &((&1-1) < 0 && [6,8] || [&1-1])) end

res = Enum.reduce(1..80, timers, fn _, ts_acc -> time_step.(ts_acc) end)

IO.puts(Enum.count(res))
