defmodule Tweedle.AccountsSetups do
  @moduledoc """
    Functions for preparing users in test blocks
  """

  alias Tweedle.{Accounts, AccountsFixtures}

  def create_user(%{skip_create_user: _}), do: :ok

  def create_user(_) do
    %{email: email, id: user_id} = AccountsFixtures.user_fixture!()
    {:ok, email: email, password: "passworD1234", user_id: user_id}
  end

  def create_author(%{skip_create_author: _}), do: :ok

  def create_author(_) do
    %{id: author_id} = AccountsFixtures.user_fixture!()
    {:ok, author_id: author_id}
  end

  def create_follow(%{skip_create_follow: _}), do: :ok

  def create_follow(%{author_id: author_id, user_id: user_id}) do
    Accounts.create_follow!(author_id, user_id)
    :ok
  end
end
