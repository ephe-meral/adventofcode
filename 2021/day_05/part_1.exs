#! /usr/bin/env elixir

# NB: This is only for horiz or vertical lines!
point_on_line_ = fn
  {px, py}, {{ax, py}, {bx, py}} when ax < bx -> (ax <= px and px <= bx) # horiz
  {px, py}, {{ax, py}, {bx, py}} when bx < ax -> (bx <= px and px <= ax)
  {px, py}, {{px, ay}, {px, by}} when ay < by -> (ay <= py and py <= by) # vert
  {px, py}, {{px, ay}, {px, by}} when by < ay -> (by <= py and py <= ay)
  _,        _                                 -> false end

point_on_line = fn p, ln -> point_on_line_.(p, ln) && 1 || 0 end

extract_xs = fn {{ax, _}, {bx, _}} -> [ax, bx] end
extract_ys = fn {{_, ay}, {_, by}} -> [ay, by] end

lines =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(fn x -> String.split(x, " -> ") end)
  |> Enum.map(fn x ->
    Enum.map(x, fn y ->
      String.split(y, ",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple() end)
    |> List.to_tuple() end)

{min_x, max_x} = Enum.flat_map(lines, &extract_xs.(&1)) |> Enum.min_max()
{min_y, max_y} = Enum.flat_map(lines, &extract_ys.(&1)) |> Enum.min_max()

res =
  (for x <- min_x..max_x, y <- min_y..max_y, do: {x,y})
  |> Enum.map(fn p -> Enum.map(lines, &point_on_line.(p, &1)) |> Enum.sum() end)
  |> Enum.filter(fn x -> x >= 2 end)
  |> Enum.count()

IO.inspect(res)
