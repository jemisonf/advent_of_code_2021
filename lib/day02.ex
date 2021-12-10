defmodule Day2 do
  def parse_instructions([], instructions) do
    instructions
  end

  def parse_instructions([line | lines], instructions) do
    [instr, count] = String.split(line, " ", parts: 2)

    parsed_count = String.to_integer(count)

    instruction = {instr, parsed_count}

    parse_instructions(lines, instructions ++ [instruction])
  end

  def evaluate_instructions([], position) do
    position
  end

  def evaluate_instructions([instruction | instructions], {depth, forward}) do
    case instruction do
      {"forward", amt} -> evaluate_instructions(instructions, {depth, forward + amt})
      {"down", amt} -> evaluate_instructions(instructions, {depth + amt, forward})
      {"up", amt} -> evaluate_instructions(instructions, {depth - amt, forward})
      _ -> evaluate_instructions(instructions, {depth, forward})
    end
  end

  def evaluate_instructions_pt2([], position) do
    position
  end

  def evaluate_instructions_pt2([instruction | instructions], {depth, forward, aim}) do
    case instruction do
      {"forward", amt} ->
        evaluate_instructions_pt2(instructions, {depth + aim * amt, forward + amt, aim})

      {"down", amt} ->
        evaluate_instructions_pt2(instructions, {depth, forward, aim + amt})

      {"up", amt} ->
        evaluate_instructions_pt2(instructions, {depth, forward, aim - amt})

      _ ->
        evaluate_instructions_pt2(instructions, {depth, forward, aim})
    end
  end

  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    lines = String.split(String.trim(contents), "\n")

    instructions = parse_instructions(lines, [])

    {depth, forward} = evaluate_instructions(instructions, {0, 0})

    IO.inspect(depth, label: "Depth")
    IO.inspect(forward, label: "Forward")
    IO.inspect(depth * forward, label: "Answer")

    IO.puts("--Part 2")

    {depth, forward, _} = evaluate_instructions_pt2(instructions, {0, 0, 0})

    IO.inspect(depth, label: "Depth")
    IO.inspect(forward, label: "Forward")
    IO.inspect(depth * forward, label: "Answer")
  end
end
