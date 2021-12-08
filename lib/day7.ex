defmodule Day7 do
  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    positions =
      Enum.sort(Enum.map(String.split(String.trim(contents), ","), &String.to_integer/1))

    {sum, _} =
      Enum.reduce(Enum.with_index(tl(positions), 1), {0, hd(positions)}, fn {position, idx},
                                                                            {sum, last} ->
        options =
          Enum.map(last..position, fn new_position ->
            {
              Enum.reduce(Enum.slice(positions, 0..idx), 0, fn pos, count ->
                count + abs(new_position - pos)
              end),
              new_position
            }
          end)

        IO.inspect(options, charlists: :as_list)

        Enum.min_by(options, fn {sum, _} -> sum end)
      end)

    IO.inspect(sum, label: "Fuel Cost")
  end
end
