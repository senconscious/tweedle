defmodule TweedleWeb.TweedController do
  use TweedleWeb, :controller

  alias Tweedle.Tweeds

  def index(conn, _params) do
    tweeds = Tweeds.list_tweeds()
    render(conn, "index.json", tweeds: tweeds)
  end
end
