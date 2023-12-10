#! /usr/bin/env elixir

# Read input into a matrix (list of lists), and add coordinates to each cell
input =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "", trim: true))
  # Replace each '.' char with empty string
  |> Enum.map(fn x -> Enum.map(x, fn y -> String.replace(y, ".", "") end) end)
  # Assign each cell a coordinate and a 'infected' state (any non-digit symbol is infected)
  |> Enum.with_index(1)
  |> Enum.map(fn {row, i} ->
    row
    |> Enum.with_index(1)
    |> Enum.map(fn {cell, j} -> {cell, {i, j}, String.match?(cell, ~r/\D/)} end)
  end)

# After the first iteration we can disregard everything that is not a number
get_infected = fn input, only_numbers ->
  input
  |> List.flatten()
  |> Enum.filter(fn {cell, _, infected} ->
    cell != "" and
    ((only_numbers and String.match?(cell, ~r/\d/)) or not only_numbers) and
    infected end)
end

# Create a function that takes coordinates and checks if another set of coords is adjacent
# Note that "symbol" cells are always adjacent to any other cell, but numbers only in the same line
is_adjacent = fn {x, y}, {sym, {x1, y1}, true} ->
  cond do
    String.match?(sym, ~r/\D/) -> abs(x - x1) <= 1 and abs(y - y1) <= 1
    String.match?(sym, ~r/\d/) -> x == x1 and abs(y - y1) <= 1
    true -> false
  end
end

spread_infection = fn i, input ->
  IO.write(".")
  input
  |> Enum.map(fn row -> Enum.map(row, fn
      {"", coords, infected} -> {"", coords, infected}
      {cell, coords, true} -> {cell, coords, true}
      {cell, coords, false} -> {cell , coords, Enum.any?(get_infected.(input, i > 0), fn c -> is_adjacent.(coords, c) end)}
    end)
  end)
end

res =
  # Spread the infection
  Stream.unfold({0, false, input}, fn
    {_, input, input} -> nil
    {i, _, input} -> {input, {i+1, input, spread_infection.(i, input)}}
  end)
  |> Enum.to_list()
  |> Enum.reverse()
  |> hd()
  # Set any uninfected numbers to empty
  |> Enum.map(fn row -> Enum.map(row, fn {cell, coords, infected} ->
      {(if String.match?(cell, ~r/\d/) and not infected, do: "", else: cell), coords, infected}
    end)
  end)
  # Remove metadata, leaving only the characters
  |> Enum.map(fn row -> Enum.map(row, fn {cell, _, _} -> cell end) end)
  # Set any non-digit symbols to empty
  |> Enum.map(fn row -> Enum.map(row, fn cell -> if String.match?(cell, ~r/\D/), do: "", else: cell end) end)
  # Blow up empty strings to spaces
  |> Enum.map(fn row -> Enum.map(row, fn cell -> if cell == "", do: " ", else: cell end) end)
  # Join rows into strings
  |> Enum.map(fn row -> Enum.join(row, "") |> String.trim() |> String.replace("  ", " ") end)
  # Join rows into one big string
  |> Enum.join(" ")
  # Split by spaces and convert to numbers and sum
  |> String.split(" ", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sum()

IO.inspect(res)
