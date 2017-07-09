defmodule TicTacToe.Web.GameChannel do
  use Phoenix.Channel

  alias TicTacToe.Board
  alias TicTacToe.Player

  def join("game:" <> _id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("move", %{"board" => board, "index" => index, "player" => player}, socket) do
    player = String.to_atom(player)
    board = serialize_board(board)

    if Board.empty?(board, index) && !Board.winner?(board) do
      next_player = Player.next(player)

      board =
        board
        |> Board.move(index, player)
        |> Board.next_board(next_player)

      broadcast!(socket, "move", %{board: board, player: next_player})
    end

    if Board.winner(board) do
      broadcast!(socket, "over", %{winner: Board.winner(board)})
    end

    if Board.over?(board) do
      broadcast!(socket, "over", %{winner: "nobody"})
    end

    {:noreply, socket}
  end

  defp serialize_board(board) do
    Enum.map(board, fn(e) ->
      case e do
        "" -> nil
        _ -> String.to_atom(e)
      end
    end)
  end
end
