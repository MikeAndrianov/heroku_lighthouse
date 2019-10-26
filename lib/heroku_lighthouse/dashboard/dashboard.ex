defmodule HerokuLighthouse.Dashboard do
  import Ecto.Query, warn: false
  alias HerokuLighthouse.Repo
  alias HerokuLighthouse.HerokuApi.Client
  alias HerokuLighthouse.Accounts.{User}
  alias HerokuLighthouse.Accounts

  def list_teams(user) do
    user
    |> Accounts.access_token()
    |> Client.get_teams()
  end

  def cached_grouped_apps(user) do
    Cachex.get!(:cache_warehouse, user_applications_cache_name(user)) || fetch_apps_async(user)
  end

  def user_applications_cache_name(user), do: "user_#{user.id}_apps"

  def filter_grouped_apps(user, ""), do: cached_grouped_apps(user)

  def filter_grouped_apps(user, query) do
    user
    |> cached_grouped_apps
    |> Enum.reduce([], fn {team, apps}, acc ->
      [{team, filter_apps(apps, query)} | acc]
    end)
    |> Enum.reject(fn {_, apps} -> length(apps) == 0 end)
  end

  defp fetch_apps_async(user) do
    Phoenix.PubSub.broadcast(HerokuLighthouse.PubSub, "dashboard:#{user.id}", :fetching_apps)

    # If you are using async tasks, you must await a reply as they are always sent.
    # Use Task.start_link if you are not expecting a reply
    Task.start_link(fn ->
      fetch_and_cache_apps(user)

      Phoenix.PubSub.broadcast(HerokuLighthouse.PubSub, "dashboard:#{user.id}", :apps_fetched)
    end)

    []
  end

  defp fetch_and_cache_apps(user) do
    with cached_apps <- grouped_apps(user),
         true <-
           Cachex.put!(:cache_warehouse, "user_#{user.id}_apps", cached_apps,
             ttl: :timer.hours(24)
           ) do
      cached_apps
    end
  end

  # %{ team_name: [apps], ...}
  def grouped_apps(user) do
    user
    |> list_teams
    |> fetch_apps_for_teams(user)
    |> Map.put(%{name: "Personal"}, personal_apps(user))
    |> Enum.reject(fn {_, apps} -> length(apps) == 0 end)
    |> Enum.map(fn {team, apps} -> {team, put_domains_to_apps(apps, user)} end)
  end

  defp fetch_apps_for_teams(teams, user) do
    Map.new(teams, fn team -> {team, team_apps(team, user)} end)
  end

  # TODO: try to make it parallel with Stream
  defp team_apps_with_domains(team, user) do
    team
    |> team_apps(user)
    |> Enum.map(fn app -> Map.put(app, :domains, app_domains(app, user)) end)
  end

  defp team_apps(team, user) do
    user
    |> Accounts.access_token()
    |> Client.team_app_list_by_team(team.id)
  end

  defp put_domains_to_apps(apps, user) do
    apps
    |> Task.async_stream(&({&1, app_domains(&1, user)}), ordered: true)
    |> Enum.reduce([], fn({:ok, {app, app_domains}}, acc) -> [Map.put(app, :domains, app_domains) | acc] end)
    |> Enum.reverse()
    # |> Enum.map(&Map.put(&1, :domains, app_domains(&1, user)))
  end

  defp app_domains(app, user) do
    user
    |> Accounts.access_token()
    |> Client.get_domains_for_app(app.id)
    |> Enum.map(& &1.hostname)
  end

  # TODO: personal also include shared by team apps. remove them from personal
  defp personal_apps(user) do
    user
    |> Accounts.access_token()
    |> Client.app_list()
    |> Enum.reject(& &1.team)
  end

  defp filter_apps(apps, query) do
    apps
    |> Enum.filter(
      &(&1.name =~ query || &1.web_url =~ query ||
          Enum.any?(&1.domains, fn domain -> domain =~ query end))
    )
  end
end
