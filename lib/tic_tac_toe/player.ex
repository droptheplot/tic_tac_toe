defmodule TicTacToe.Player do
  def next(:x), do: :o
  def next(:o), do: :x
end
