defmodule Day9 do
  def is_low_point([x, y], board) do
    0..3
    |> Enum.reduce(true, fn row_idx, is_low_point ->
      is_low_point &&
        Enum.reduce(0..3, true, fn col_idx, is_low_point ->
          IO.inspect({{row_idx, col_idx}, board[row_idx][col_idx]})

          case board[row_idx][col_idx] do
            nil -> is_low_point
            val -> val > board[x][y] && is_low_point
          end
        end)
    end)
  end

  def build_board(contents) do
    contents
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, idx}, map ->
      row =
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {char, idx}, row ->
          Map.put(row, idx, String.to_integer(char))
        end)

      Map.put(map, idx, row)
    end)
  end

  def main(args) do
    contents = Common.read_file(args)

    board = build_board(contents)

    rows = board |> Map.keys() |> length()
    cols = board[0] |> Map.keys() |> length()

    points =
      0..rows
      |> Enum.flat_map(fn row_idx -> Enum.map(0..cols, fn col_idx -> {row_idx, col_idx} end) end)

    IO.inspect(points)

    sum =
      Enum.reduce(points, 0, fn {row_idx, col_idx}, sum ->
        if is_low_point([row_idx, col_idx], board) do
          sum + board[row_idx][col_idx] + 1
        else
          sum
        end
      end)

    IO.inspect(sum, label: "Part 1 result")
  end
end
