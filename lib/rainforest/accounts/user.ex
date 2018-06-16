defmodule Rainforest.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :encrypted_password, :string
    field :username, :string
    field :usertype, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :usertype, :encrypted_password])
    |> validate_required([:username, :usertype, :encrypted_password])
    |> unique_constraint(:username)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
