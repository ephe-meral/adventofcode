#! /usr/bin/env elixir

# NB: Conversion needs be in order!
convert = [
  # Overlaps first
  {"oneight", "18"},
  {"twone", "21"},
  {"threeight", "38"},
  {"fiveight", "58"},
  {"sevenine", "79"},
  {"eightwo", "82"},
  {"eighthree", "83"},
  {"nineight", "98"},

  {"one", "1"},
  {"two", "2"},
  {"three", "3"},
  {"four", "4"},
  {"five", "5"},
  {"six", "6"},
  {"seven", "7"},
  {"eight", "8"},
  {"nine", "9"},
]

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  # Use convert to replace all digit names with digits within each string
  |> Enum.map(fn x -> Enum.reduce(convert, x, fn {k, v}, acc -> String.replace(acc, k, v) end) end)
  # Filter each char in the string to only include digits
  |> Enum.map(fn x -> String.replace(x, ~r/\D/, "") end)
  # # Take first and last character of each string
  |> Enum.map(fn x -> String.slice(x, 0, 1) <> String.slice(x, -1, 1) end)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()

IO.inspect(res)
