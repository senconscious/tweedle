defmodule TweedleWeb.User.FollowView do
  use TweedleWeb, :view

  def render("create.json", %{follow: follow}) do
    %{
      data: render_one(follow, __MODULE__, "follow.json")
    }
  end

  def render("delete.json", %{follow: follow}) do
    %{
      data: render_one(follow, __MODULE__, "follow_short.json")
    }
  end

  def render("follow.json", %{follow: follow}) do
    %{
      author_id: follow.author_id,
      follower_id: follow.follower_id,
      inserted_at: follow.inserted_at,
      updated_at: follow.updated_at
    }
  end

  def render("follow_short.json", %{follow: follow}) do
    %{
      author_id: follow.author_id,
      follower_id: follow.follower_id
    }
  end
end
