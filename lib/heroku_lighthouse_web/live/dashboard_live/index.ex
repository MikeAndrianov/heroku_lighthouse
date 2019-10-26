defmodule HerokuLighthouseWeb.DashboardLive.Index do
  use Phoenix.LiveView
  alias HerokuLighthouse.Dashboard
  alias HerokuLighthouseWeb.DashboardView

  # TODO: prevent multiple fetch if there is no value in cache (currently fetching),
  # but user uses search input
  def mount(session, socket) do
    user = session[:user]
    is_fetching = Map.get(socket.assigns, :fetching_apps, false)
    Phoenix.PubSub.subscribe(HerokuLighthouse.PubSub, "dashboard:#{user.id}")

    apps_by_team = Dashboard.cached_grouped_apps(user)

    {:ok, assign(socket, apps_by_team: apps_by_team, current_user: session[:user], fetching_apps: is_fetching)}
  end

  def render(assigns) do
    DashboardView.render("index.html", assigns)
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) do
    filtered_apps_by_team = Dashboard.filter_grouped_apps(socket.assigns.current_user, query)

    {:noreply, assign(socket, apps_by_team: filtered_apps_by_team)}
  end

  def handle_info(:fetching_apps, socket) do
    {:noreply, assign(socket, fetching_apps: true)}
  end

  def handle_info(:apps_fetched, socket) do
    apps_by_team = Dashboard.cached_grouped_apps(socket.assigns.current_user)

    {:noreply, assign(socket, apps_by_team: apps_by_team, fetching_apps: false)}
  end
end
