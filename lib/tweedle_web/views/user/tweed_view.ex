defmodule TweedleWeb.User.TweedView do
  use TweedleWeb, :view

  alias TweedleWeb.TweedView

  def render("show.json", %{tweed: tweed}) do
    %{
      data: render_one(tweed, TweedView, "tweed.json")
    }
  end

  def render("delete.json", %{tweed: tweed}) do
    %{
      data: %{
        id: tweed.id
      }
    }
  end
end
