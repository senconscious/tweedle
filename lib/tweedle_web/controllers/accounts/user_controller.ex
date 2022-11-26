defmodule TweedleWeb.Accounts.UserController do
  use TweedleWeb, :controller

  def show(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "show.json", user: user)
  end
end
