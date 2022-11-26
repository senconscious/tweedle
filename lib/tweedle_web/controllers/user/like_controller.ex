defmodule TweedleWeb.User.LikeController do
  use TweedleWeb, :controller

  alias Tweedle.Tweeds

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.id]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"tweed_id" => tweed_id}, user_id) do
    like = Tweeds.create_like!(tweed_id, user_id)
    render(conn, "show.json", like: like)
  end

  def delete(conn, %{"tweed_id" => tweed_id}, user_id) do
    like = Tweeds.delete_like!(tweed_id, user_id)
    render(conn, "show.json", like: like)
  end
end
