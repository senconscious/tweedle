defmodule TweedleWeb.User.FollowController do
  use TweedleWeb, :controller

  alias Tweedle.Accounts

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user.id]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"profile_id" => author_id}, follower_id) do
    follow = Accounts.create_follow!(author_id, follower_id)
    render(conn, "create.json", follow: follow)
  end

  def delete(conn, %{"profile_id" => profile_id}, follower_id) do
    follow = Accounts.delete_follow!(profile_id, follower_id)
    render(conn, "delete.json", follow: follow)
  end
end
