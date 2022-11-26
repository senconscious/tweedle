defmodule Tweedle.Accounts.Follow do
  @moduledoc """
    Schema for follow
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Tweedle.Accounts.User

  @primary_key false
  schema "follows" do
    belongs_to :author, User, primary_key: true
    belongs_to :follower, User, primary_key: true

    timestamps()
  end

  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:author_id, :follower_id])
    |> validate_required([:author_id, :follower_id])
    |> foreign_key_constraint(:author_id)
    |> foreign_key_constraint(:follower_id)
    |> validate_author_follower_distinct()
    |> unique_constraint([:author_id, :follower_id], name: :follows_pkey)
  end

  defp validate_author_follower_distinct(
         %{valid?: true, changes: %{author_id: author_id, follower_id: follower_id}} = changeset
       ) do
    if author_id == follower_id do
      add_error(changeset, :follower_id, "can't be as author")
    else
      changeset
    end
  end

  defp validate_author_follower_distinct(changeset), do: changeset
end
