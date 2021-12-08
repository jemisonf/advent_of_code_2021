defmodule Day6 do
  def initial_buckets do
    Enum.reduce(0..9, %{}, fn idx, buckets -> Map.put(buckets, idx, 0) end)
  end

  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    fish = Enum.map(String.split(String.trim(contents), ","), &String.to_integer/1)

    IO.inspect(fish)

    buckets =
      Enum.reduce(fish, initial_buckets(), fn fish, buckets ->
        Map.update(buckets, fish, 1, fn count -> count + 1 end)
      end)

    final_buckets =
      Enum.reduce(1..80, buckets, fn day, buckets ->
        IO.inspect(day, label: "Day")
        IO.inspect(buckets, label: "Buckets")

        Enum.reduce(0..9, %{}, fn idx, new_buckets ->
          case idx do
            0 ->
              Map.merge(
                new_buckets,
                %{
                  0 => 0,
                  6 => buckets[0],
                  8 => buckets[0]
                }
              )

            _ ->
              Map.merge(
                new_buckets,
                %{
                  (idx - 1) => buckets[idx],
                  idx => 0
                },
                fn _, count1, count2 -> count1 + count2 end
              )
          end
        end)
      end)

    count = Enum.reduce(0..9, 0, fn idx, acc -> acc + final_buckets[idx] end)

    IO.inspect(count, label: "Count")
  end
end
