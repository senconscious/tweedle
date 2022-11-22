defmodule Tweedle.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes, primary_key: false) do
      add :tweed_id, references(:tweeds), null: false, primary_key: true
      add :user_id, references(:users), null: false, primary_key: true

      timestamps()
    end
  end
end
