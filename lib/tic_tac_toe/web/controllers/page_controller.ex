defmodule TicTacToe.Web.PageController do
  use TicTacToe.Web, :controller

  alias TicTacToe.Board

  def index(conn, _params) do
    board =
      Board.new
      |> Enum.chunk(3)

    render conn, "index.html", board: board
  end
end
