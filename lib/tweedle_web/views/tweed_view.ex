defmodule TweedleWeb.TweedView do
  use TweedleWeb, :view

  def render("index.json", %{tweeds: tweeds}) do
    %{
      data: render_many(tweeds, __MODULE__, "tweed.json")
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
