defmodule TweedleWeb.Accounts.TokenController do
  use TweedleWeb, :controller

  alias Tweedle.Accounts
  alias Tweedle.Auth.Guardian.Plug, as: GuardianPlug

  action_fallback TweedleWeb.FallbackController

  def sign_up(conn, %{"user" => params}) do
    with {:ok, token, _claims} <- Accounts.sign_up!(params) do
      render(conn, "sign_in.json", token: token)
    end
  end

  def sign_in(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, token, _claims} <- Accounts.sign_in!(email, password) do
      render(conn, "sign_in.json", token: token)
    end
  end

  def sign_out(conn, _params) do
    token = GuardianPlug.current_token(conn)

    with {:ok, _claims} <- Accounts.sign_out(token) do
      resp(conn, 204, "")
    end
  end
end
