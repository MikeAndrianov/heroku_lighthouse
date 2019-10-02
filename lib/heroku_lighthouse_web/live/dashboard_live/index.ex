defmodule HerokuLighthouseWeb.DashboardLive.Index do
  use Phoenix.LiveView
  alias HerokuLighthouse.HerokuEntities.Entities
  alias HerokuLighthouseWeb.DashboardView

  def mount(session, socket) do
    apps_by_team = Entities.cached_grouped_apps(session[:user])

    {:ok, assign(socket, apps_by_team: apps_by_team, current_user: session[:user])}
  end

  def render(assigns) do
    DashboardView.render("index.html", assigns)
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) do
    filtered_apps_by_team = Entities.filter_grouped_apps(socket.assigns.current_user, query)

    {:noreply, assign(socket, :apps_by_team, filtered_apps_by_team)}
  end
end
