defmodule TicTacToe.Board do
  @size 0..8
  @infinity -9000

  alias TicTacToe.Player

  def winner([p, p, p, _, _, _, _, _, _]), do: p
  def winner([_, _, _, p, p, p, _, _, _]), do: p
  def winner([_, _, _, _, _, _, p, p, p]), do: p
  def winner([p, _, _, p, _, _, p, _, _]), do: p
  def winner([_, p, _, _, p, _, _, p, _]), do: p
  def winner([_, _, p, _, _, p, _, _, p]), do: p
  def winner([p, _, _, _, p, _, _, _, p]), do: p
  def winner([_, _, p, _, p, _, p, _, _]), do: p
  def winner([_, _, _, _, _, _, _, _, _]), do: nil

  def winner?(board, p) do
    winner(board) == p
  end

  def new do
    Enum.map(@size, fn(_) -> nil end)
  end

  def empty?(board, index) do
    is_nil(Enum.at(board, index))
  end

  def move(board, index, player) do
    List.replace_at(board, index, player)
  end

  def next_board(board, p) do
    if over?(board) do
      board
    else
      List.replace_at(board, next_move(board, p), p)
    end
  end

  @doc """
  Returns index for best move.

  ## Parameters

    - board: List e.g. `[nil, nil, :x]`
    - p: Player e.g. `:x` or `:o`

  ## Examples

    iex> TicTacToe.Board.next_move([:x, nil, :x, nil, :o, nil, nil, :o, nil], :x)
    1

    iex> TicTacToe.Board.next_move([:x, nil, :x, nil, :o, nil, nil, :o, nil], :o)
    1

  """
  def next_move(board, p) do
    next_move(board, p, 0)
  end

  def next_move(board, p, depth) do
    cond do
      winner?(board, Player.next(p)) ->
        -10 + depth
      over?(board) ->
        0
      true ->
        max = @infinity
        index = 0

        {max, index} =
          Enum.map(@size, fn(i) ->
            case Enum.at(board, i) do
              nil ->
                weight = -next_move(List.replace_at(board, i, p), Player.next(p), depth + 1)
                {weight, i}
              _ ->
                nil
            end
          end)
          |> Enum.reject(&is_nil/1)
          |> Enum.reduce({@infinity, nil}, fn(e, acc) ->
            if elem(e, 0) >= elem(acc, 0), do: e, else: acc
          end)

        case depth do
          0 -> index
          _ -> max
        end
    end
  end

  @doc """
  Checks if board is full.

  ## Examples

    iex> TicTacToe.Board.over?([:x, :o, nil])
    false

    iex> TicTacToe.Board.over?([:x, :o, :x])
    true

  """
  def over?(board) do
    !Enum.any?(board, &is_nil/1)
  end
end
