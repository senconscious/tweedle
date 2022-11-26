defmodule TweedleWeb.User.ProfileController do
  use TweedleWeb, :controller

  alias Tweedle.Accounts

  def index_followed(conn, _params) do
    %{id: follower_id} = conn.assigns.current_user

    profiles = Accounts.list_followed_users(follower_id)
    render(conn, "index_followed.json", profiles: profiles)
  end
end
