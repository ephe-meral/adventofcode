#! /usr/bin/env elixir

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  # Filter each char in the string to only include digits
  |> Enum.map(fn x -> String.replace(x, ~r/\D/, "") end)
  # Take first and last character of each string
  |> Enum.map(fn x -> String.slice(x, 0, 1) <> String.slice(x, -1, 1) end)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()

IO.inspect(res)
