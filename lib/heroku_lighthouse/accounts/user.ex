defmodule HerokuLighthouse.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias HerokuLighthouse.Accounts.Token

  schema "users" do
    field :email, :string

    has_one :token, HerokuLighthouse.Accounts.Token

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end

  # def access_token(user) do
  #   token = user.token

  #   if Token.expired?(token) do

  #   else
  #     token.access_token
  #   end
  # end
end
