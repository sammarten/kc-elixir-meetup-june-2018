defmodule TrainingCenterWeb.RequireUser do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]
  import TrainingCenterWeb.Router.Helpers, only: [session_path: 2]

  def init(opts) do
    opts
  end

  def call(conn, _opts) do 
    if get_session(conn, :current_user) do
      conn
    else
      redirect_to_session(conn)
    end
  end

  defp redirect_to_session(conn) do
    conn
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end
end