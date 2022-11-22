defmodule TweedleWeb.TweedController do
  use TweedleWeb, :controller

  alias Tweedle.Tweeds

  def index(conn, _params) do
    tweeds = Tweeds.list_tweeds()
    render(conn, "index.json", tweeds: tweeds)
  end

  def show(conn, %{"id" => id}) do
    tweed = Tweeds.get_tweed!(id)
    render(conn, "show.json", tweed: tweed)
  end
end
