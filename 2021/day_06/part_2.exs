#! /usr/bin/env elixir

timers =
  File.read!("input.txt")
  |> String.trim()
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

# Counter for each timer state (by index, i.e. initally: [0, 0, 0, 0, 0, 0, 0, 0, 0]
sim_state = Enum.map(0..8, fn x -> timers |> Enum.filter(&(&1==x)) |> Enum.count() end)

time_step = fn ss ->
  [hd | new_ss] = ss
  new_ss = new_ss ++ [hd] # add new 8's
  new_ss = List.replace_at(new_ss, 6, (hd + Enum.at(new_ss, 6))) # update 6's
end

res = Enum.reduce(1..256, sim_state, fn i, ts_acc -> time_step.(ts_acc) end)

IO.puts(Enum.sum(res))
