defmodule TweedleWeb.Router do
  use TweedleWeb, :router

  alias TweedleWeb.Pipelines.AuthorizedAccess

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :ensure_authorized_access do
    plug AuthorizedAccess
  end

  scope "/api", TweedleWeb do
    pipe_through :api

    scope "/accounts", Accounts, as: :accounts do
      post "/sign_up", TokenController, :sign_up
      post "/sign_in", TokenController, :sign_in

      pipe_through :ensure_authorized_access
      post "/sign_out", TokenController, :sign_out
    end

    get "/tweeds", TweedController, :index

    scope "/user", User, as: :user do
      pipe_through :ensure_authorized_access

      resources "/tweeds", TweedController, only: [:create, :delete] do
        resources "/likes", LikeController, only: [:create, :delete], singleton: true
      end

      patch "/tweeds/:id", TweedController, :update

      get "/likes", LikeController, :index
    end
  end
end
