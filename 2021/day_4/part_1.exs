#! /usr/bin/env elixir

defmodule Mat do
  def transp([[] | _]), do: []
  def transp(m), do: [Enum.map(m, &hd/1) | transp(Enum.map(m, &tl/1))]
end

[head | tail] =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n", trim: true)

ran_nums =
  head
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

bingos =
  tail
  |> Enum.chunk_every(5)
  |> Enum.map(fn b ->
      Enum.map(b, &String.split(&1, " ", trim: true))
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end) end)
  |> Enum.map(fn b -> b ++ Mat.transp(b) end)

mark_num = fn b, num -> Enum.map(b, &Enum.filter(&1, fn x -> x != num end)) end

check_bingo = fn b -> Enum.any?(b, fn b_row -> b_row == [] end) end

{ran_num, idx, end_bingos} =
  Enum.reduce_while(ran_nums, {nil, nil, bingos}, fn ran_num, {_, _, bs} ->
    new_bs = bs |> Enum.map(&mark_num.(&1, ran_num))
    winning_idx = new_bs |> Enum.find_index(&(check_bingo.(&1)))

    case winning_idx do
      nil -> {:cont, {ran_num, nil, new_bs}}
      _   -> {:halt, {ran_num, winning_idx, new_bs}}
    end
  end)

calc_score = fn ran_num, idx, bs ->
    # NB: we need to div by 2 cause earlier we dup'd all values with transp and concat
    ran_num * round((bs |> Enum.at(idx) |> Enum.map(&Enum.sum/1) |> Enum.sum()) / 2)
  end

IO.inspect(calc_score.(ran_num, idx, end_bingos))
