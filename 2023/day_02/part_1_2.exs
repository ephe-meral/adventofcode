#! /usr/bin/env elixir

# Max cubes of each color, "red", "green", and "blue"
preset_counts = {12, 13, 14} # test.txt and input.txt

# Convert cube count and color to tuple
color_convert = fn s ->
  [count, color] = String.split(String.trim(s), " ", trim: true)
  {String.to_atom(color), String.to_integer(count)} # Atom needed? There be dragons
end

# Convert a list of tuples of cube color and count to a tuple of counts
# (tuple position refers to the color, which can be "red", "green", or "blue", each color occurs only once)
set_convert = fn l ->
  Enum.reduce(l, {0, 0, 0}, fn {color, count}, {r, g, b} ->
    case color do
      :red -> {r + count, g, b}
      :green -> {r, g + count, b}
      :blue -> {r, g, b + count}
    end
  end)
end

# Get maximum counts for each color per game
max_counts = fn l ->
  Enum.reduce(l, {0, 0, 0}, fn {r, g, b}, {r_max, g_max, b_max} ->
    {max(r, r_max), max(g, g_max), max(b, b_max)}
  end)
end

# Filter each game against maximum allowed cubes (i.e. return bool)
filter_game = fn {r, g, b} ->
  r <= elem(preset_counts, 0) and g <= elem(preset_counts, 1) and b <= elem(preset_counts, 2)
end

res =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  # Remove the "Game N:" start of each string, where N is an integer
  |> Enum.map(fn x -> String.replace(x, ~r/^Game \d+: /, "", trim: true) end)
  # Split each 'game' into sets via the ';' character
  |> Enum.map(fn x -> String.split(x, ";", trim: true) end)
  # Split each 'set' into individual cube counts via the ',' character
  |> Enum.map(fn x -> Enum.map(x, fn y -> String.split(y, ",", trim: true) end) end)
  # Convert each cube count and color to tuple
  |> Enum.map(fn x -> Enum.map(x, fn y -> Enum.map(y, color_convert) end) end)
  # Convert each set to a tuple of counts
  |> Enum.map(fn x -> Enum.map(x, set_convert) end)
  # Convert each game to a tuple of maximum counts
  |> Enum.map(fn x -> max_counts.(x) end)

res_1 =
  res
  # Enumerate the games
  |> Enum.with_index(1)
  # Filter each game against maximum allowed cubes
  |> Enum.filter(fn {game, _} -> filter_game.(game) end)
  # Sum the indices of the games that pass the filter
  |> Enum.map(fn {_, i} -> i end)
  |> Enum.sum()

res_2 =
  res
  # Multiply the maximum counts of each game
  |> Enum.map(fn {r, g, b} -> r * g * b end)
  # Sum the products
  |> Enum.sum()

IO.inspect(res_1)
IO.inspect(res_2)
