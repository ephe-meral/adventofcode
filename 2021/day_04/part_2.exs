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

res =
  Enum.reduce_while(ran_nums, [{nil, [], bingos}], fn ran_num, [{_, _, bs} | _] = acc ->
    {winning_bs, new_bs} =
      bs
      |> Enum.map(&mark_num.(&1, ran_num))
      |> Enum.split_with(&check_bingo.(&1))

    case new_bs do
      [] -> {:halt, [{ran_num, winning_bs, new_bs} | acc]}
      _  -> {:cont, [{ran_num, winning_bs, new_bs} | acc]}
    end
  end)

{ran_num, [end_bingos | _], _} = Enum.at(res, 0)

calc_score = fn ran_num, b ->
    # NB: we need to div by 2 cause earlier we dup'd all values with transp and concat
    ran_num * round((b |> Enum.map(&Enum.sum/1) |> Enum.sum()) / 2)
  end

IO.inspect(calc_score.(ran_num, end_bingos))
