defmodule Tweedle.Tweeds.Like do
  @moduledoc """
    Schema for tweed like
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Tweedle.Accounts.User
  alias Tweedle.Tweeds.Tweed

  @primary_key false
  schema "likes" do
    belongs_to :tweed, Tweed, primary_key: true
    belongs_to :user, User, primary_key: true

    timestamps()
  end

  def changeset(like, attrs) do
    like
    |> cast(attrs, [:tweed_id, :user_id])
    |> validate_required([:tweed_id, :user_id])
    |> foreign_key_constraint(:tweed_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:tweed_id, :user_id], message: "already liked", name: :likes_pkey)
  end
end
