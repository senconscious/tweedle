defmodule TweedleWeb.Accounts.TokenView do
  use TweedleWeb, :view

  def render("sign_in.json", %{token: token}) do
    %{
      data: render_one(token, __MODULE__, "token.json")
    }
  end

  def render("token.json", %{token: token}) do
    %{
      token: token
    }
  end
end
