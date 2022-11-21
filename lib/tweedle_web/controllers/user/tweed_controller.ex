defmodule TweedleWeb.User.TweedController do
  use TweedleWeb, :controller

  alias Tweedle.Tweeds

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.id]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"tweed" => params}, user_id) do
    tweed = Tweeds.create_tweed!(user_id, params)
    render(conn, "show.json", tweed: tweed)
  end

  def update(conn, %{"id" => id, "tweed" => params}, _user_id) do
    tweed = Tweeds.update_tweed!(id, params)
    render(conn, "show.json", tweed: tweed)
  end

  def delete(conn, %{"id" => id}, _user_id) do
    tweed = Tweeds.delete_tweed!(id)
    render(conn, "delete.json", tweed: tweed)
  end
end
