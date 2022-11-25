defmodule Tweedle.AccountsSetups do
  @moduledoc """
    Functions for preparing users in test blocks
  """

  alias Tweedle.AccountsFixtures

  def create_user(%{skip_create_user: _}), do: :ok

  def create_user(_) do
    password = "passworD1234"
    %{email: email, id: user_id} = AccountsFixtures.user_fixture!(%{password: password})
    {:ok, email: email, password: password, user_id: user_id}
  end
end
