defmodule Final.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :user, :integer

      timestamps()
    end

  end
end
