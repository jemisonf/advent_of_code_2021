defmodule Day3 do
  def place_bit(num, place) do
    use Bitwise
    Bitwise.band(num, 1 <<< place) >>> (place)
  end

  def count_place(line, place, {zeros_count, ones_count}) do
    bit = place_bit(line, place)

    case bit do
      0 -> {zeros_count + 1, ones_count}
      1 -> {zeros_count, ones_count + 1}
      _ -> {zeros_count, ones_count}
    end
  end

  def count_places([], place_counts, _) do
    place_counts
  end

  def count_places([line | lines], place_counts, count) do
    count_places(
      lines,
      Enum.map(
        Enum.zip(place_counts, 0..count),
        fn {place_count, idx} ->
          count_place(line, idx, place_count)
        end
      ),
      count
    )
  end

  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    lines =
      Enum.map(String.split(String.trim(contents), "\n"), fn line ->
        String.to_integer(line, 2)
      end)

    line_size = String.length(hd(String.split(contents)))

    counts =
      count_places(
        lines,
        for _ <- 0..(line_size - 1) do
          {0, 0}
        end,
        line_size
      )

    IO.inspect(counts)

    gamma =
      Enum.reduce(Enum.zip(counts, 0..line_size), 0, fn {{zeroes, ones}, idx}, acc ->
        if ones > zeroes do
          acc + Integer.pow(2, idx)
        else
          acc
        end
      end)

    epsilon =
      Enum.reduce(Enum.zip(counts, 0..line_size), 0, fn {{zeroes, ones}, idx}, acc ->
        if ones < zeroes do
          acc + Integer.pow(2, idx)
        else
          acc
        end
      end)

    IO.inspect(Integer.to_string(gamma, 2), label: "gamma")
    IO.inspect(Integer.to_string(epsilon, 2), label: "epsilon")

    IO.inspect(epsilon * gamma, label: "Pt 1 result")
    IO.inspect(line_size)

    o2_rating =
      Enum.reduce((line_size - 1)..0, lines, fn place, lines ->
        # IO.inspect(Enum.map(lines, fn line -> Integer.to_string(line, 2) end))
        # IO.inspect(place, label: "Place")

        {zero_count, one_count} =
          Enum.reduce(lines, {0, 0}, fn line, counts -> count_place(line, place, counts) end)

        bit =
          if zero_count > one_count do
            0
          else
            1
          end

        # IO.inspect(bit, label: "Bit")

        if tl(lines) == [] do
          lines
        else
          Enum.filter(lines, fn line ->
            place_bit(line, place) == bit
          end)
        end
      end)

    IO.inspect(Integer.to_string(hd(o2_rating), 2), label: "o2 rating")

    co2_rating =
      Enum.reduce((line_size - 1)..0, lines, fn place, lines ->
        # IO.inspect(Enum.map(lines, fn line -> Integer.to_string(line, 2) end))
        # IO.inspect(place, label: "Place")

        {zero_count, one_count} =
          Enum.reduce(lines, {0, 0}, fn line, counts -> count_place(line, place, counts) end)

        bit =
          if zero_count <= one_count do
            0
          else
            1
          end

        # IO.inspect(bit, label: "Bit")

        if tl(lines) == [] do
          lines
        else
          Enum.filter(lines, fn line ->
            place_bit(line, place) == bit
          end)
        end
      end)

    IO.inspect(Integer.to_string(hd(co2_rating), 2), label: "co2 rating")

    IO.inspect(hd(co2_rating) * hd(o2_rating), label: "Pt 2 result")
  end
end
