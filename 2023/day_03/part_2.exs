#! /usr/bin/env elixir

# Read input into a matrix (list of lists), and add coordinates to each cell
input =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "", trim: true))
  # Replace each '.' char with empty string
  |> Enum.map(fn x -> Enum.map(x, fn y -> String.replace(y, ".", "") end) end)
  # Replace each non-digit char that is not a 'gear ('*') with empty string
  |> Enum.map(fn x -> Enum.map(x, fn y -> String.replace(y, ~r/[^0-9*]/, "") end) end)
  # Assign each cell a coordinate and a 'infected' state (any non-digit symbol is infected)
  |> Enum.with_index(1)
  |> Enum.map(fn {row, i} ->
    row
    |> Enum.with_index(1)
    # Instead of just being "infected" or not, actually safe the source of infection
    |> Enum.map(fn {cell, j} -> {cell, {i, j}, String.match?(cell, ~r/\D/) and {i, j}} end)
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
is_adjacent = fn {x, y}, {sym, {x1, y1}, infection_source} ->
  cond do
    String.match?(sym, ~r/\D/) -> (abs(x - x1) <= 1 and abs(y - y1) <= 1) and infection_source
    String.match?(sym, ~r/\d/) -> (x == x1 and abs(y - y1) <= 1) and infection_source
    true -> false
  end
end

spread_infection = fn i, input ->
  IO.write(".")
  input
  |> Enum.map(fn row -> Enum.map(row, fn
      {"", coords, infected} -> {"", coords, infected}
      {cell, coords, {x, y}} -> {cell, coords, {x, y}}
      {cell, coords, false} -> {cell , coords, Enum.find_value(get_infected.(input, i > 0), false, fn c -> is_adjacent.(coords, c) end)}
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
      {(if String.match?(cell, ~r/\d/) and not !!infected, do: "", else: cell), coords, infected}
    end)
  end)
  # Remove coords
  |> Enum.map(fn row -> Enum.map(row, fn {cell, _, infected} -> {cell, infected} end) end)
  # Set any non-digit symbols to empty
  |> Enum.map(fn row -> Enum.map(row, fn {cell, infected} -> if String.match?(cell, ~r/\D/), do: {"", false}, else: {cell, infected} end) end)
  # Join rows, such that we get a flat list, and intersperse with empty thingies
  |> Enum.intersperse([{"", false}])
  |> List.flatten()
  |> Enum.chunk_by(fn {cell, _} -> cell == "" end)
  |> Enum.map(&Enum.unzip/1)
  # Remove empty elements
  |> Enum.filter(fn {_, infected} -> Enum.any?(infected) end)
  # Convert to numbers and match up
  |> Enum.map(fn {cells, infected} -> {hd(infected), Enum.join(cells, "") |> String.to_integer()} end)
  |> Enum.group_by(fn {infected, _} -> infected end)
  # Convert back to values and clean up,
  |> Map.values()
  |> Enum.map(fn x -> Enum.map(x, fn {_, y} -> y end) end)
  # Discard any with more or less than two elements
  |> Enum.filter(fn x -> length(x) == 2 end)
  # Multiply the two elements
  |> Enum.map(fn [x, y] -> x * y end)
  # Sum the products
  |> Enum.sum()

IO.inspect(res)
