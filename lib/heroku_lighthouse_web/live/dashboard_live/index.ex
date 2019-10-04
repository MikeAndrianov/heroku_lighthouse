defmodule HerokuLighthouseWeb.DashboardLive.Index do
  use Phoenix.LiveView
  alias HerokuLighthouse.HerokuEntities.Entities
  alias HerokuLighthouseWeb.DashboardView

  # TODO: prevent multiple fetch if there is no value in cache (currently fetching),
  # but user uses seatch input
  def mount(session, socket) do
    user = session[:user]
    apps_by_team = Entities.cached_grouped_apps(user)

    Phoenix.PubSub.subscribe(HerokuLighthouse.PubSub, "dashboard:#{user.id}")

    {:ok, assign(socket, apps_by_team: apps_by_team, current_user: session[:user])}
  end

  def render(assigns) do
    DashboardView.render("index.html", assigns)
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) do
    filtered_apps_by_team = Entities.filter_grouped_apps(socket.assigns.current_user, query)

    {:noreply, assign(socket, :apps_by_team, filtered_apps_by_team)}
  end

  def handle_info(:apps_fetched, socket) do
    apps_by_team = Entities.cached_grouped_apps(socket.assigns.current_user)

    {:noreply, assign(socket, apps_by_team: apps_by_team)}
  end
end
