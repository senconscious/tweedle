defmodule TweedleWeb.User.TweedController do
  use TweedleWeb, :controller

  alias Tweedle.Tweeds

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.id]
    apply(__MODULE__, action_name(conn), args)
  end

  def index_followed(conn, _params, user_id) do
    tweeds = Tweeds.list_followed_tweeds(user_id)
    render(conn, "index_followed.json", tweeds: tweeds)
  end

  def index_liked(conn, _params, user_id) do
    tweeds = Tweeds.list_liked_tweeds(user_id)
    render(conn, "index_liked.json", tweeds: tweeds)
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
