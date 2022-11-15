defmodule Tweedle.Repo do
  use Ecto.Repo,
    otp_app: :tweedle,
    adapter: Ecto.Adapters.Postgres
end
