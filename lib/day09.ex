defmodule Day9 do
  def adjacent_points({x, y}, board) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y + 1},
      {x, y - 1}
    ] |> Enum.filter(fn {x, y} -> board[x][y] != 9 && board[x][y] != nil end)
  end

  def is_low_point({x, y}, board) do
    IO.inspect({{x, y}, board[x][y]})
    is_lp = x - 1..x + 1
    |> Enum.reduce(true, fn row_idx, is_low_point ->
      # IO.inspect(row_idx)
        is_low_point && Enum.reduce(y - 1..y + 1, true, fn col_idx, is_low_point ->
          # IO.inspect({{row_idx, col_idx}, board[row_idx][col_idx], is_low_point})

          if row_idx == x && col_idx == y do
            is_low_point
          else
            case board[row_idx][col_idx] do
              nil -> is_low_point
              val -> val > board[x][y] && is_low_point
            end
          end
        end)
    end)

    is_lp
  end

  def find_basin(low_point, board) do
    {lp_x, lp_y} = low_point
    adjacent_points = adjacent_points(low_point, board)
      |> Enum.filter(fn {ap_x, ap_y} -> board[ap_x][ap_y] != 9 && board[ap_x][ap_y] > board[lp_x][lp_y] end)

    IO.inspect(adjacent_points)

    [low_point] ++ Enum.flat_map(adjacent_points, fn adjacent_point -> [adjacent_point] ++ find_basin(adjacent_point, board) end)
      |> MapSet.new |> MapSet.to_list
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

    low_points = points
      |> Enum.filter(fn point -> is_low_point(point, board) end)

    sum = low_points
      |> Enum.map(fn {row_idx, col_idx} -> board[row_idx][col_idx] + 1 end)
      |> Enum.sum()
    IO.inspect(sum, label: "Part 1 result")

    basins = low_points |> Enum.map(fn low_point -> low_point |> find_basin(board) end)

    # IO.inspect(basins)

    top_three_basins = basins |> Enum.sort_by(&Enum.count/1, :desc) |> Enum.slice(0..2)

    IO.inspect(top_three_basins)

    p2result = Enum.reduce(top_three_basins, 1, fn basin, acc -> Enum.count(basin) * acc end)

    IO.inspect(p2result, label: "Part 2 result")
  end
end
