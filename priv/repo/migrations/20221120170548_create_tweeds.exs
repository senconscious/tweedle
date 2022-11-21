defmodule Tweedle.Repo.Migrations.CreateTweeds do
  use Ecto.Migration

  def change do
    create table(:tweeds) do
      add :author_id, references(:users), null: false
      add :message, :string, null: false
      timestamps()
    end
  end
end
