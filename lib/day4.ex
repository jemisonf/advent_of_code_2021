defmodule Day4 do
  def winning_sequences(board) do
    Enum.concat([
      Enum.map(0..4, fn row_idx -> MapSet.new(Enum.map(0..4, fn col_idx -> board[row_idx][col_idx] end)) end),
      Enum.map(0..4, fn col_idx -> MapSet.new(Enum.map(0..4, fn row_idx -> board[row_idx][col_idx] end)) end),
      [
        MapSet.new(Enum.map(0..4, fn idx -> board[idx][idx] end)),
        MapSet.new(Enum.map(0..4, fn idx -> board[4 - idx][idx] end)),
      ]
    ])
  end
  def board(lines) do
    Enum.reduce(Enum.with_index(String.split(lines, "\n")), %{}, fn {row, row_idx}, board ->
      cols = Enum.map(String.split(row), &String.to_integer/1)
      Map.merge(board,
        %{row_idx =>
          Enum.reduce(Enum.with_index(cols), %{}, fn {col, col_idx}, row ->
            Map.merge(row, %{col_idx => col})
          end)
        }
      )
    end)
  end

  def sliding_windows(list, windows) do
    if length(list) < 5 do
      windows
    else
      sliding_windows(tl(list), windows ++ [Enum.slice(list, 0, 5)])
    end
  end

  def main(args) do
    options = [switches: [file: :string]]
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect(opts, label: "Args")

    {:ok, contents} = File.read(opts[:file])

    lines = String.split(String.trim(contents), "\n\n")

    nums = Enum.map(String.split(hd(lines), ","), &String.to_integer/1)

    raw_boards = tl(lines)

    IO.inspect(nums, label: "nums")

    boards = Enum.map(raw_boards, &board/1)

    all_winning_sequences = Enum.map(boards, &winning_sequences/1)

    {idx, _} = List.foldl(nums, {0, all_winning_sequences}, fn num, {score, sequences} ->
      if score != 0 do
        {score, sequences}
      else
        updated_sequences = Enum.map(sequences, fn sequence_list ->
          Enum.map(sequence_list, fn sequence -> MapSet.delete(sequence, num) end)
        end)

        winning_sequences = Enum.find(updated_sequences, nil, fn sequences ->
          Enum.any?(sequences, fn sequence -> MapSet.size(sequence) == 0 end)
        end)

        if winning_sequences == nil do
          {0, updated_sequences}
        else
          unmarked_values = MapSet.to_list(MapSet.new(Enum.flat_map(winning_sequences, &MapSet.to_list/1)))

          IO.inspect(unmarked_values)

          sum = Enum.reduce(unmarked_values, 0, fn num, acc -> num + acc end)

          IO.inspect(sum, label: "Sum")
          IO.inspect(num, label: "num")

          {sum * num, updated_sequences}
        end
      end
    end)

    IO.inspect(idx, label: "Winning Score")

  end
end
