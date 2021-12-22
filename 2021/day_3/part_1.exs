#! /usr/bin/env elixir

# Helpers for some math / conversion stuff that doesn't exist in std

defmodule Mat do
  def transp([[] | _]), do: []
  def transp(m), do: [Enum.map(m, &hd/1) | transp(Enum.map(m, &tl/1))]
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

input_bins =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(fn x -> String.split(x, "", trim: true) end)
  |> Enum.map(fn x -> Enum.map(x, &String.to_integer/1) end)
  |> Mat.transp()

input_len = Enum.count(Enum.at(input_bins, 0))

[maj, min] =
  input_bins
  |> Enum.map(&Enum.sum/1)
  |> Enum.map(fn x ->
      [(x > round(input_len/2)) && 1 || 0,
       (x < round(input_len/2)) && 1 || 0]
    end)
  |> Mat.transp()
  |> Enum.map(fn x -> Enum.into(x, <<>>, fn bit -> <<bit :: 1>> end) end)
  |> Enum.map(fn x -> Bitop.bitstring_to_uint(x) end)

IO.inspect(maj * min)
