defmodule TweedleWeb.User.ProfileView do
  use TweedleWeb, :view

  def render("index_followed.json", %{profiles: profiles}) do
    %{
      data: render_many(profiles, __MODULE__, "profile.json")
    }
  end

  def render("profile.json", %{profile: profile}) do
    %{
      id: profile.id,
      username: profile.username,
      inserted_at: profile.inserted_at
    }
  end
end
