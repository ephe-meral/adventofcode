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

score = fn
  ")" -> 3
  "]" -> 57
  "}" -> 1197
  ">" -> 25137
end

res =
  Enum.map(lines, fn ln ->
    Enum.reduce_while(ln, [], fn op, stack ->
      case stack_op.(stack, op) do
        {:ok, stack} -> {:cont, stack}
        error        -> {:halt, error}
      end
    end)
    |> case do
      {:error, {_, op}} -> score.(op)
      _                 -> 0
    end
  end)
  |> Enum.sum()

IO.inspect(res)
