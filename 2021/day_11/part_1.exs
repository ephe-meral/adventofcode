#! /usr/bin/env elixir

timers =
  File.read!("input_test.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "", trim: true))
  |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)

IO.inspect(timers)
