defmodule TweedleWeb.Router do
  use TweedleWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TweedleWeb do
    pipe_through :api
  end
end
