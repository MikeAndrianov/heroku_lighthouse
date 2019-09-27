defmodule HerokuLighthouseWeb.DashboardView do
  use HerokuLighthouseWeb, :view
  alias HerokuLighthouse.HerokuApi.Client

  def get_domains(conn, app_id_or_name) do
    response =
      Client.get_domains_for_app(
        Plug.Conn.get_session(conn, :access_token) || conn.assigns[:access_token],
        app_id_or_name
      )

    domains_to_string(response)
  end

  defp domains_to_string(response) when is_map(response), do: "No access"

  defp domains_to_string(response) when is_list(response) do
    response
    |> Enum.map(fn domain -> domain["hostname"] end)
    |> Enum.join(", ")
  end
end
