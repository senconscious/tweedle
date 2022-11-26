defmodule TweedleWeb.ProfileView do
  use TweedleWeb, :view

  def render("index.json", %{profiles: profiles}) do
    %{
      data: render_many(profiles, __MODULE__, "profile.json")
    }
  end

  def render("show.json", %{profile: profile}) do
    %{
      data: render_one(profile, __MODULE__, "profile.json")
    }
  end

  def render("profile.json", %{profile: profile}) do
    %{
      id: profile.id,
      name: profile.name,
      username: profile.username,
      inserted_at: profile.inserted_at
    }
  end
end
