defmodule TweedleWeb.TweedView do
  use TweedleWeb, :view

  def render("index.json", %{tweeds: tweeds}) do
    %{
      data: render_many(tweeds, __MODULE__, "tweed_with_likes.json")
    }
  end

  def render("show.json", %{tweed: tweed}) do
    %{
      data: render_one(tweed, __MODULE__, "tweed_with_likes_and_replies.json")
    }
  end

  def render("tweed_with_likes.json", %{tweed: tweed}) do
    %{
      id: tweed.id,
      message: tweed.message,
      author_id: tweed.author_id,
      likes: tweed.likes,
      inserted_at: tweed.inserted_at,
      updated_at: tweed.updated_at
    }
  end

  def render("tweed_with_likes_and_replies.json", %{tweed: tweed}) do
    %{
      id: tweed.id,
      message: tweed.message,
      author_id: tweed.author_id,
      likes: tweed.likes,
      replies: render_many(tweed.replies, __MODULE__, "tweed.json"),
      inserted_at: tweed.inserted_at,
      updated_at: tweed.updated_at
    }
  end

  def render("tweed.json", %{tweed: tweed}) do
    %{
      id: tweed.id,
      message: tweed.message,
      author_id: tweed.author_id,
      inserted_at: tweed.inserted_at,
      updated_at: tweed.updated_at
    }
  end
end
