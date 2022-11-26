defmodule TweedleWeb.User.TweedView do
  use TweedleWeb, :view

  alias TweedleWeb.TweedView

  def render(template, %{tweeds: tweeds})
      when template in ["index_followed.json", "index_liked.json"] do
    %{
      data: render_many(tweeds, TweedView, "tweed_with_likes.json")
    }
  end

  def render("show.json", %{tweed: tweed}) do
    %{
      data: render_one(tweed, __MODULE__, "tweed.json")
    }
  end

  def render("delete.json", %{tweed: tweed}) do
    %{
      data: render_one(tweed, __MODULE__, "tweed_short.json")
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

  def render("tweed_short.json", %{tweed: tweed}) do
    %{
      id: tweed.id
    }
  end
end
