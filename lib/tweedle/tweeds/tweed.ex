defmodule Tweedle.Tweeds.Tweed do
  @moduledoc """
    Schema for tweed
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias Tweedle.Accounts.User
  alias Tweedle.Tweeds.Like

  schema "tweeds" do
    belongs_to :author, User
    belongs_to :parent, __MODULE__

    has_many :likes, Like
    has_many :replies, __MODULE__, foreign_key: :parent_id

    many_to_many :liked_users, User, join_through: Like

    field :message, :string

    timestamps()
  end

  def changeset(tweed, attrs) do
    tweed
    |> cast(attrs, [:author_id, :message])
    |> base_creation_changeset()
  end

  def reply_changeset(tweed, attrs) do
    tweed
    |> cast(attrs, [:author_id, :message, :parent_id])
    |> validate_required([:parent_id])
    |> foreign_key_constraint(:parent_id)
    |> base_creation_changeset()
  end

  def update_changeset(tweed, attrs) do
    tweed
    |> cast(attrs, [:message])
    |> validate_required([:message])
    |> validate_length(:message, max: 256)
  end

  defp base_creation_changeset(changeset) do
    changeset
    |> validate_required([:author_id, :message])
    |> validate_length(:message, max: 256)
    |> foreign_key_constraint(:author_id)
  end
end
