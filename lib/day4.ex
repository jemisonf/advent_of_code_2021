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

  def scan_rows(board) do
    Enum.reduce(0..4, false, fn col_idx, found ->
      found || Enum.reduce(0..4, true, fn row_idx, inner_found -> inner_found && board[col_idx][row_idx] == true end)
    end)
  end

  def scan_columns(board) do
    Enum.reduce(0..4, false, fn row_idx, found ->
      found || Enum.reduce(0..4, true, fn col_idx, inner_found -> inner_found && board[col_idx][row_idx] == true  end)
    end)
  end

  def scan_diagonals(board) do
    Enum.reduce(0..4, true, fn idx, found -> found && board[idx][idx] == true end) ||
    Enum.reduce(0..4, true, fn idx, found -> found && board[4 - idx][idx] == true end)
  end

  def update_boards(boards, num) do
    Enum.map(boards, fn board ->
        Enum.reduce(0..4, board, fn row_idx, updated_board ->
          Map.merge(
            updated_board,
            %{row_idx =>
              Enum.reduce(0..4, updated_board[row_idx], fn col_idx, row ->
                Map.merge(row, %{col_idx => cond do
                    row[col_idx] == num -> true
                    true -> row[col_idx]
                  end})
              end)
            }
          )
        end)
      end)
  end

  def count_unmarked(board) do
    Enum.reduce(0..4, 0, fn row_idx, sum ->
            sum + Enum.reduce(0..4, 0, fn col_idx, col_sum ->
              if board[row_idx][col_idx] == true do
                col_sum
              else
                col_sum + board[row_idx][col_idx]
              end
            end)
        end)

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

    Enum.reduce(nums, boards, fn num, boards ->
      updated_boards = update_boards(boards, num)

      board = Enum.find(updated_boards, nil, fn board ->
        scan_columns(board) || scan_rows(board) || scan_diagonals(board)
      end)

      IO.inspect(num, label: "Num")
      if board != nil do
        sum = count_unmarked(board)
        IO.inspect(sum, label: "Sum")

        IO.inspect(sum * num, label: "Result")
      end

      updated_boards
    end)

    IO.puts("---- part 2")

    Enum.reduce(nums, boards, fn num, boards ->
      updated_boards = update_boards(boards, num)

      board = Enum.find(updated_boards, nil, fn board ->
        scan_columns(board) || scan_rows(board) || scan_diagonals(board)
      end)

      if board != nil && Enum.count(updated_boards) == 1 do
        sum = count_unmarked(board)
        IO.inspect(sum, label: "Sum")

        IO.inspect(sum * num, label: "Result")
      end

      Enum.filter(updated_boards, fn b ->
        !(scan_columns(b) || scan_rows(b) || scan_diagonals(b))
      end)
    end)
  end
end
