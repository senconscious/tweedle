defmodule Tweedle.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows, primary_key: false) do
      add :author_id, references(:users), primary_key: true
      add :follower_id, references(:users), primary_key: true

      timestamps()
    end
  end
end
