defmodule Tweedle.Accounts do
  @moduledoc """
    Accounts context
  """

  import Ecto.Query

  alias EctoJuno.Query.Sorting
  alias Tweedle.Accounts.{Follow, User}
  alias Tweedle.Auth.Guardian
  alias Tweedle.Repo

  def create_user!(params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert!()
  end

  def list_users, do: Repo.all(User)

  def list_followed_users(follower_id) do
    User
    |> join(:inner, [a], f in Follow,
      on: a.id == f.author_id and f.follower_id == ^follower_id,
      as: :follows
    )
    |> Sorting.sort_query(Follow, %{sort_direction: "desc"}, :follows)
    |> Repo.all()
  end

  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email!(email), do: Repo.get_by!(User, email: email)

  def update_user!(%User{} = user, params) do
    user
    |> User.changeset(params, :update)
    |> Repo.update!()
  end

  def delete_user!(%User{} = user), do: Repo.delete!(user)

  @spec sign_up!(map()) :: {:ok, binary(), map()} | {:error, any()}
  def sign_up!(params) do
    params
    |> create_user!()
    |> Guardian.encode_and_sign()
  end

  @spec sign_in!(binary(), binary()) :: {:ok, binary(), map()} | {:error, any()}
  def sign_in!(email, password) do
    with {:ok, user} <- check_user_password!(email, password) do
      Guardian.encode_and_sign(user)
    end
  end

  defp check_user_password!(email, password) do
    email
    |> get_user_by_email!()
    |> Bcrypt.check_pass(password)
  end

  @spec sign_out(binary()) :: {:ok, map()} | {:error, any()}
  def sign_out(token) do
    Guardian.revoke(token)
  end

  def get_follow!(author_id, follower_id),
    do: Repo.get_by!(Follow, author_id: author_id, follower_id: follower_id)

  def create_follow!(author_id, follower_id) do
    %Follow{}
    |> Follow.changeset(%{author_id: author_id, follower_id: follower_id})
    |> Repo.insert!()
  end

  def delete_follow!(author_id, follower_id) do
    author_id
    |> get_follow!(follower_id)
    |> Repo.delete!()
  end
end
