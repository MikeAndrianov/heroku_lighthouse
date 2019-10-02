defmodule HerokuLighthouse.Accounts do
  import Ecto.{Query, Multi}, warn: false
  alias Ecto.Multi
  alias HerokuLighthouse.Repo
  alias HerokuLighthouse.Accounts.{User, Token}
  alias HerokuLighthouse.HerokuApi.{Client, Oauth}

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email!(email), do: Repo.get_by!(User, email: email)

  def fetch_token_and_account(heroku_callback_code) do
    with token_response <- Oauth.fetch_token(heroku_callback_code),
         account_attributes <- Client.get_account(token_response["access_token"]) do
      Multi.new()
      |> Multi.run(:user, fn _repo, _changes -> find_or_create_user(account_attributes) end)
      |> Multi.run(:token, fn _repo, %{user: user} ->
        create_or_update_token(user, token_response)
      end)
      |> Repo.transaction()
    end
  end

  def find_or_create_user(%{"email" => email} = attrs) do
    cond do
      user = Repo.get_by(User, email: email) ->
        {:ok, user}

      true ->
        create_user(attrs)
    end
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def get_token!(user), do: user.token

  def create_or_update_token(user, attrs \\ %{}) do
    case token = Repo.get_by(Token, user_id: user.id) do
      %Token{} ->
        token
        |> Token.changeset(attrs)
        |> Repo.update()

      nil ->
        user
        |> Ecto.build_assoc(:token)
        |> Token.changeset(attrs)
        |> Repo.insert()
    end
  end

  def update_token(token, attrs) do
    token
    |> Token.refresh_token_changeset(attrs)
    |> Repo.update!()
  end

  def access_token(%User{id: user_id}) do
    token = Repo.get_by(Token, user_id: user_id)

    if Token.expired?(token) do
      refreshed_attrs = Oauth.token_refresh(token.refresh_token)
      __MODULE__.update_token(token, refreshed_attrs).access_token
    else
      token.access_token
    end
  end
end
