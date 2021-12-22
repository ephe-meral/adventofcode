#! /usr/bin/env elixir

# Helpers for some math / conversion stuff that doesn't exist in std

defmodule Mat do
  def transp([]), do: []
  def transp([[] | _]), do: []
  def transp(m), do: [Enum.map(m, &hd/1) | transp(Enum.map(m, &tl/1))]

  def col_at(m, i), do: Enum.at(transp(m), i)
end

defmodule Bitop do
  def pad_leading_zeros(bs) when is_binary(bs), do: bs
  def pad_leading_zeros(bs) when is_bitstring(bs) do
    pad_length = 8 - rem(bit_size(bs), 8)
    <<0::size(pad_length), bs::bitstring>>
  end

  def bitstring_to_uint(bs),
    do: bs |> Bitop.pad_leading_zeros |> :binary.decode_unsigned()
end

# Actual business logic

defmodule Logic do
  def filter(m) do
    [filter(m, 0, Enum.count(Enum.at(m, 0)), &Kernel.>=/2),
     filter(m, 0, Enum.count(Enum.at(m, 0)), &Kernel.</2)]
  end

  def filter([row], _, _, _), do: row
  def filter(m, i, max_i, _) when i == max_i, do: hd(m)
  def filter(m, i, max_i, comp_func) when i < max_i do
    col =  Mat.col_at(m, i)
    filter_val = (comp_func.(Enum.sum(col), round(Enum.count(col)/2))) && 1 || 0

    Enum.filter(m, fn row -> Enum.at(row, i) == filter_val end)
    |> filter(i+1, max_i, comp_func)
  end
end

[maj, min] =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(fn x -> String.split(x, "", trim: true) end)
  |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
  |> Logic.filter()
  |> Enum.map(fn x -> Enum.into(x, <<>>, fn bit -> <<bit :: 1>> end) end)
  |> Enum.map(fn x -> Bitop.bitstring_to_uint(x) end)

IO.inspect(maj * min)
