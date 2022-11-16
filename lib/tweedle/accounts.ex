defmodule Tweedle.Accounts do
  @moduledoc """
    Accounts context
  """

  alias Tweedle.Accounts.User
  alias Tweedle.Repo

  def create_user!(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert!()
  end

  def list_users, do: Repo.all(User)

  def get_user!(id), do: Repo.get!(User, id)

  def update_user!(%User{} = user, params) do
    user
    |> User.changeset(params, :update)
    |> Repo.update!()
  end

  def delete_user!(%User{} = user), do: Repo.delete!(user)
end
