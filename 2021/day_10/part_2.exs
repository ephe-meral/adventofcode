#! /usr/bin/env elixir

lines =
  File.read!("input.txt")
  |> String.trim()
  |> String.split("\n")
  |> Enum.map(&String.split(&1, "", trim: true))

stack_op = fn
  stack, op when op in ["(", "[", "{", "<"] -> {:ok, [op | stack]}
  ["(" | stack], ")" -> {:ok, stack}
  ["[" | stack], "]" -> {:ok, stack}
  ["{" | stack], "}" -> {:ok, stack}
  ["<" | stack], ">" -> {:ok, stack}
  stack, op -> {:error, {stack, op}}
end

score = Map.new(Enum.with_index(["(", "[", "{", "<"], 1))

res =
  Enum.map(lines, fn ln ->
    Enum.reduce_while(ln, [], fn op, stack ->
      case stack_op.(stack, op) do
        {:ok, stack} -> {:cont, stack}
        error        -> {:halt, error}
      end
    end)
  end)
  |> Enum.filter(fn
    {:error, _} -> false
    _           -> true
  end)
  |> Enum.map(&Enum.reduce(&1, 0, fn x, acc -> (acc * 5) + score[x] end))
  |> Enum.sort()

final = Enum.at(res, round(Enum.count(res)/2) - 1)

IO.inspect(final)
