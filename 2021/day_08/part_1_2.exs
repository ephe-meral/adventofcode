#! /usr/bin/env elixir

input =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, " | ", trim: true))
  |> Enum.map(fn p -> Enum.map(p, fn x ->
    String.split(x, " ", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.sort/1) end) end)

contains_pattern = fn pattern, digit -> (pattern -- digit) == [] end

create_mapping = fn enc ->
  enc = enc |> Enum.sort_by(&Enum.count/1)

  enc_2_3_5 = Enum.slice(enc, 3, 3)
  enc_0_6_9 = Enum.slice(enc, 6, 3)

  mapping = %{
    1 => Enum.at(enc, 0),
    7 => Enum.at(enc, 1),
    4 => Enum.at(enc, 2),
    8 => Enum.at(enc, 9)
  }

  pat_4_1 = mapping[4] -- mapping[1]

  {[mapping_0], enc_6_9} = Enum.split_with(enc_0_6_9, fn x -> !contains_pattern.(pat_4_1, x) end)
  {[mapping_6], [mapping_9]} = Enum.split_with(enc_6_9, fn x -> !contains_pattern.(mapping[1], x) end)

  {[mapping_3], enc_2_5} = Enum.split_with(enc_2_3_5, fn x -> contains_pattern.(mapping[1], x) end)
  {[mapping_5], [mapping_2]} = Enum.split_with(enc_2_5, fn x -> contains_pattern.(pat_4_1, x) end)

  mapping = Map.merge(mapping, %{
    0 => mapping_0,
    6 => mapping_6,
    9 => mapping_9,
    3 => mapping_3,
    5 => mapping_5,
    2 => mapping_2,
  })

  Map.new(mapping, fn {key, val} -> {val, key} end)
end

res =
  input
  |> Enum.map(fn [enc, dig] ->
    m = create_mapping.(enc)
    Enum.map(dig, fn d -> m[d] end)
  end)

# For part 2
combine_digits = fn ds ->
  ds |> Enum.reverse() |> Enum.with_index() |> Enum.map(fn {d, i} -> d * (10**i) end) |> Enum.sum()
end

IO.write("Part 1: ")
IO.inspect(res |> List.flatten() |> Enum.filter(fn x -> (x==1 or x==4 or x==7 or x==8) end) |> Enum.count)

IO.write("Part 2: ")
IO.inspect(res |> Enum.map(&combine_digits.(&1)) |> Enum.sum())
