defmodule Day2 do
  def parse_instructions([], instructions) do instructions end
  def parse_instructions([line | lines], instructions) do
    [instr, count] = String.split(line, " ", parts: 2)

    parsed_count = String.to_integer(count)

    instruction = case instr do
      "forward" -> {:forward, parsed_count}
      "up" -> {:up, parsed_count}
      "down" -> {:down, parsed_count}
    end

    parse_instructions(lines, instructions ++ instruction)
  end

  def evaluate_instructions([], position) do position end
  def evaluate_instructions([{instruction, amt}, instructions], {depth, forward}) do
    case instruction do
      :forward -> evaluate_instructions(instructions, {depth, forward + amt})
      :down -> evaluate_instructions(instructions, {depth - amt, forward})
      :up -> evaluate_instructions(instructions, {depth + amt, forward})
    end
  end
  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    lines = String.split(contents, "\n")

    instructions = parse_instructions(lines, [])

    {depth, forward} = evaluate_instructions(instructions, {0, 0})

    IO.inspect(depth, label: "Depth")
    IO.inspect(forward, label: "Forward")


  end

end
