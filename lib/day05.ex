defmodule Day5 do

  def parse_lines([], parsed_lines) do parsed_lines end
  def parse_lines([line | lines], parsed_lines) do
    [[x1], [y1], [x2], [y2]] = Regex.scan(~r/(?:\d+)/, line)

    parse_lines(lines, parsed_lines ++ [{
      {
        String.to_integer(x1),
        String.to_integer(y1),
      },
      {
        String.to_integer(x2),
        String.to_integer(y2),
      }
    }])
  end

  def intersections({{x1, y1}, {x2, y2}}) do
    if !(x1 == x2 || y1 == y2) do
      Enum.zip(x1..x2, y1..y2)
    else
      MapSet.to_list(MapSet.new(Enum.concat(
        Enum.map(x1..x2, fn x -> {x, y1} end),
        Enum.map(y1..y2, fn y -> {x1, y} end)
      )))
    end
  end
  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    lines = String.split(String.trim(contents), "\n")

    parsed_lines = parse_lines(lines, [])

    IO.inspect(parsed_lines, label: "Lines")

    intersections = Enum.flat_map(parsed_lines, &intersections/1)

    res = Enum.reduce(intersections, %{}, fn intersection, counter ->
      Map.update(counter, intersection, 1, fn count -> count + 1 end)
    end)

    IO.inspect(res, label: "Results")

    intersections = Enum.reduce(Map.keys(res), 0, fn key, counter ->
      if res[key] > 1 do
        counter + 1
      else
        counter
      end
    end)

    IO.inspect(intersections, label: "Intersections")
  end
end
