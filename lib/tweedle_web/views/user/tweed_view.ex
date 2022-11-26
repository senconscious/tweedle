defmodule TweedleWeb.User.TweedView do
  use TweedleWeb, :view

  def render("index_followed.json", %{tweeds: tweeds}) do
    %{
      data: render_many(tweeds, __MODULE__, "tweed_followed.json")
    }
  end

  def render("show.json", %{tweed: tweed}) do
    %{
      data: render_one(tweed, __MODULE__, "tweed.json")
    }
  end

  def render("delete.json", %{tweed: tweed}) do
    %{
      data: %{
        id: tweed.id
      }
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

  def render("tweed_followed.json", %{tweed: tweed}) do
    %{
      id: tweed.id,
      parent_id: tweed.parent_id,
      author_id: tweed.author_id,
      message: tweed.message,
      inserted_at: tweed.inserted_at,
      updated_at: tweed.updated_at
    }
  end
end
