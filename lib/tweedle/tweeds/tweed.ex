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

    has_many :likes, Like

    many_to_many :liked_users, User, join_through: Like

    field :message, :string

    timestamps()
  end

  def changeset(tweed, attrs) do
    tweed
    |> cast(attrs, [:author_id, :message])
    |> validate_required([:author_id, :message])
    |> validate_length(:message, max: 256)
    |> foreign_key_constraint(:author_id)
  end

  def update_changeset(tweed, attrs) do
    tweed
    |> cast(attrs, [:message])
    |> validate_required([:message])
    |> validate_length(:message, max: 256)
  end
end
