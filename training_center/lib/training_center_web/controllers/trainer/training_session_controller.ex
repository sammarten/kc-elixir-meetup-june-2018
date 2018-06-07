defmodule TrainingCenterWeb.Trainer.TrainingSessionController do
  use TrainingCenterWeb, :controller

  alias TrainingCenterWeb.Endpoint

  plug TrainingCenterWeb.RequireUser

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", id: id, name: get_session(conn, :current_user))
  end

  def start_training_session(conn, %{"id" => id}) do
    Gym.start_training_session(id)
    Endpoint.broadcast("training_session:#{id}", "training_session_started", %{})
    redirect(conn, to: trainer_training_session_path(conn, :show, id))
  end

  def stop_training_session(conn, %{"id" => id}) do
    Gym.stop_training_session(id)
    Endpoint.broadcast("training_session:#{id}", "training_session_ended", %{})
    redirect(conn, to: trainer_home_path(conn, :index))
  end
end
