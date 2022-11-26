defmodule TweedleWeb.ProfileController do
  use TweedleWeb, :controller

  alias Tweedle.Accounts

  def index(conn, _params) do
    profiles = Accounts.list_users()
    render(conn, "index.json", profiles: profiles)
  end

  def show(conn, %{"id" => id}) do
    profile = Accounts.get_user!(id)
    render(conn, "show.json", profile: profile)
  end
end
