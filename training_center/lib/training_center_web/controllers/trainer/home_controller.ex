defmodule TrainingCenterWeb.Trainer.HomeController do
  use TrainingCenterWeb, :controller

  plug TrainingCenterWeb.RequireUser

  def index(conn, _params) do
    render conn, "index.html", name: get_session(conn, :current_user)
  end
end
