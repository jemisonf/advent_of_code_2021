defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "smallest value" do
    board = Day9.build_board("999
919
999")

    assert Day9.is_low_point({1, 1}, board) == true
    assert !Day9.is_low_point({0, 0}, board) == true
  end

  test "corner case" do
    board = Day9.build_board("19
99")

    assert Day9.is_low_point({0, 0}, board) == true
    assert !Day9.is_low_point({1, 1}, board) == true
  end

  test "example board" do
    board = Day9.build_board("2199943210
3987894921
9856789892
8767896789
9899965678")

    assert Day9.is_low_point({0, 1}, board) == true
    assert Day9.is_low_point({0, 9}, board) == true
    assert Day9.is_low_point({2, 2}, board) == true
    assert Day9.is_low_point({4, 6}, board) == true


  end

  test "basins" do
    board = Day9.build_board("2199943210
3987894921
9856789892
8767896789
9899965678")

    assert Day9.find_basin({0, 1}, board) == [{0, 0}, {0, 1}, {1, 0}]
  end
end
