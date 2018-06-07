defmodule TrainingCenterWeb.TrainingSessionController do
  use TrainingCenterWeb, :controller

  plug TrainingCenterWeb.RequireUser

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", id: id, name: get_session(conn, :current_user))
  end
end
