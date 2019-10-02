defmodule HerokuLighthouse.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :access_token, :string
    # in seconds
    field :expires_in, :integer
    field :refresh_token, :string

    belongs_to :user, HerokuLighthouse.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(token, attrs) do
    token
    |> cast(attrs, [:access_token, :expires_in, :refresh_token])
    |> validate_required([:access_token, :expires_in, :refresh_token])
  end

  def refresh_token_changeset(token, attrs) do
    token
    |> cast(attrs, [:access_token])
    |> validate_required([:access_token])
  end

  def expired?(token) do
    # TODO: be carefull with updated_at. Possibly better to fetch updated_at from API
    # in case when other field than access_token, this logic could be broken
    token.updated_at
    |> DateTime.add(token.expires_in)
    |> DateTime.compare(DateTime.utc_now())
    |> (&(&1 != :gt)).()
  end
end
