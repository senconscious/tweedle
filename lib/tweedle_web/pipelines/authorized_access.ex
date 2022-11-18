defmodule TweedleWeb.Pipelines.AuthorizedAccess do
  use Guardian.Plug.Pipeline, otp_app: :tweedle

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
