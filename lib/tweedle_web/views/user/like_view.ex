defmodule TweedleWeb.User.LikeView do
  use TweedleWeb, :view

  def render("show.json", %{like: like}) do
    %{
      data: render_one(like, __MODULE__, "like.json")
    }
  end

  def render("like.json", %{like: like}) do
    %{
      user_id: like.user_id,
      tweed_id: like.tweed_id,
      inserted_at: like.inserted_at
    }
  end
end
