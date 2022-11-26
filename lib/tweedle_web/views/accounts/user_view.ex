defmodule TweedleWeb.Accounts.UserView do
  use TweedleWeb, :view

  def render("show.json", %{user: user}) do
    %{
      data: render_one(user, __MODULE__, "user.json")
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      username: user.username,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
