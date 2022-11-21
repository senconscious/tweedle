defmodule TweedleWeb.Plugs.CurrentUser do
  @moduledoc """
    Plug for injecting current user into assigns
  """

  import Plug.Conn

  alias Tweedle.Auth.Guardian

  def init(_opts), do: []

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, current_user)
  end
end
