defmodule TrainingCenterWeb.SessionController do
  use TrainingCenterWeb, :controller

  @trainer_admin "traineradmin"

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"name" => @trainer_admin}}) do
    conn
    |> put_session(:current_user, @trainer_admin)
    |> redirect(to: trainer_home_path(conn, :index))
  end

  def create(conn, %{"user" => %{"name" => name}}) do
    conn
    |> put_session(:current_user, name)
    |> redirect(to: home_path(conn, :index))
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: "/")
  end
end
