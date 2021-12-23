#! /usr/bin/env elixir

{folds, points} =
  File.read!("input.txt")
  |> String.split("\n", trim: true)
  |> Enum.split_with(&String.starts_with?(&1, "fold"))

folds =
  folds
  |> Enum.map(&String.trim_leading(&1, "fold along "))
  |> Enum.map(&String.split(&1, "="))
  |> Enum.map(fn
    ["y", y] -> [[0], [String.to_integer(y)]]
    ["x", x] -> [[String.to_integer(x)], [0]] end)

points =
  points
  |> Enum.map(&String.split(&1, ","))
  |> Enum.map(fn x -> Enum.map(x, fn y -> [String.to_integer(y)] end) end)

defmodule Mat do
  def mult(m1, m2) do
    Enum.map(m1, fn x -> Enum.map(transp(m2), fn y ->
        Enum.zip(x, y)
        |> Enum.map(fn {x, y} -> x * y end)
        |> Enum.sum()
    end) end)
  end

  def transp(m), do: List.zip(m) |> Enum.map(&Tuple.to_list(&1))

  def add(m1, m2) do
    Enum.zip(m1, m2)
    |> Enum.map(fn {row1, row2} ->
      Enum.zip(row1, row2) |> Enum.map(fn {a, b} -> a+b end)
    end)
  end
end

fold = fn points, [[fold_x], [fold_y]] = fld ->
  fold_translate_1 = [[-fold_x], [-fold_y]]
  fold_translate_2 = fld
  mirror_mat = [
    [(fold_x == 0) && 1 || -1, 0],
    [0, (fold_y == 0) && 1 || -1]]

  {points, mapped_points} = points |> Enum.split_with(
    fn [[x], [y]] ->
      ((fold_x != 0) && (x < fold_x)) ||
      ((fold_y != 0) && (y < fold_y))
    end)

  mapped_points =
    mapped_points
    |> Enum.map(&Mat.add(&1, fold_translate_1))
    |> Enum.map(&Mat.mult(mirror_mat, &1))
    |> Enum.map(&Mat.add(&1, fold_translate_2))

  Enum.uniq(points ++ mapped_points)
end

combined = fold.(points, Enum.at(folds, 0))

IO.inspect(Enum.count(combined))
