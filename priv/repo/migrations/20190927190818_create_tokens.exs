defmodule HerokuLighthouse.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :access_token, :string
      add :expires_in, :integer
      add :refresh_token, :string

      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

  end
end
