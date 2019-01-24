defmodule Final.User.Transaction do
  use Ecto.Schema
  import Ecto.Changeset


  schema "transactions" do
    field :user, :integer

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user])
    |> validate_required([:user])
  end
end
