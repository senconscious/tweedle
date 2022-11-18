defmodule TweedleWeb.Pipelines.AuthorizedAccess do
  @moduledoc """
    Pipeline that ensures that user is authorized with valid JWT for access
  """
  use Guardian.Plug.Pipeline, otp_app: :tweedle

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
