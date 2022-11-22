defmodule TweedleWeb.User.LikeView do
  use TweedleWeb, :view

  alias TweedleWeb.TweedView

  def render("index.json", %{likes: likes}) do
    %{
      data: render_many(likes, __MODULE__, "like_with_tweed.json")
    }
  end

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

  def render("like_with_tweed.json", %{like: like}) do
    %{
      tweed: render_one(like.tweed, TweedView, "tweed.json"),
      inserted_at: like.inserted_at
    }
  end
end
