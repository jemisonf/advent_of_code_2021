defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "smallest value" do
    board = Day9.build_board("999
919
999")

    IO.inspect(board)

    assert Day9.is_low_point([1, 1], board) == true
  end

  test "corner case" do
    board = Day9.build_board("19
99")

    IO.inspect(board)

    assert Day9.is_low_point([0, 0], board) == true
  end
end
