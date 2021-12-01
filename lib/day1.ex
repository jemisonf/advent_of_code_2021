defmodule DayOne do
  def list_increased([line | lines], increased_count) do
    cond do
      lines == [] ->
        increased_count

      line < hd(lines) ->
        list_increased(lines, increased_count + 1)

      line >= hd(lines) ->
        list_increased(lines, increased_count)
    end
  end

  def list_increased([], increased_count) do
    increased_count
  end

  def sliding_windows(list, windows) do
    if length(list) < 3 do
      windows
    else
      sliding_windows(tl(list), windows ++ [Enum.slice(list, 0, 3)])
    end
  end

  def sum_sliding_windows(list) do
    Enum.map(sliding_windows(list, []), &Enum.sum/1)
  end

  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    lines = Enum.map(String.split(String.trim(contents), "\n"), &String.to_integer/1)

    increased_count = list_increased(lines, 0)

    IO.inspect(increased_count, label: "Increased Count")

    sliding_window_sums = sum_sliding_windows(lines)

    sliding_windows_increased_count = list_increased(sliding_window_sums, 0)

    IO.inspect(sliding_windows_increased_count, label: "Sliding Windows Increased Count")
  end
end
