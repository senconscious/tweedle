defmodule Tweedle.Repo.Migrations.AddParentIdToTweeds do
  use Ecto.Migration

  def change do
    alter table(:tweeds) do
      add :parent_id, references(:tweeds)
    end
  end
end
