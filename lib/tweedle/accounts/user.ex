defmodule Tweedle.Accounts.User do
  @moduledoc """
    Schema for user
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Tweedle.Tweeds.Tweed

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :username, :string

    has_many :tweeds, Tweed, foreign_key: :author_id

    timestamps()
  end

  def changeset(user, attrs, action \\ :create) do
    user
    |> cast(attrs, [:email, :name, :password, :username])
    |> validate_required_fields(action)
    |> validate_length(:email, min: 6)
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/)
    |> validate_length(:password, min: 8, max: 100)
    |> validate_format(:password, ~r/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/)
    |> unique_constraint([:email])
    |> unique_constraint([:username])
    |> put_password_hash()
  end

  defp validate_required_fields(changeset, :create) do
    validate_required(changeset, [:email, :name, :password, :username])
  end

  defp validate_required_fields(changeset, :update) do
    validate_required(changeset, [:email, :name, :username])
  end

  defp put_password_hash(%{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:password, nil)
    |> change(Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
