defmodule Day8 do
  def main(args) do
    contents = Common.read_file(args)

    {inputs, outputs} =
      contents
      |> String.split("\n")
      |> Enum.map(fn line ->
        [raw_inputs, raw_ouputs] = String.split(line, "|", parts: 2)

        {
          raw_inputs |> String.trim() |> String.split(),
          raw_ouputs |> String.trim() |> String.split()
        }
      end)
      |> Enum.unzip()

    # IO.inspect(inputs)
    # IO.inspect(outputs)

    p1_count =
      outputs
      |> Enum.reduce(0, fn output, count ->
        count +
          Enum.count(output, fn sequence ->
            length = String.length(sequence)

            length == 2 || length == 3 || length == 4 || length == 7
          end)
      end)

    IO.inspect(p1_count, label: "Part 1 result")

    {inputs, outputs}
    |> Enum.zip()
    |> Enum.map(fn {input_row, output_row} ->
      nil
    end)
  end
end
