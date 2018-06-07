defmodule TrainingCenterWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "training_session:*", TrainingCenterWeb.GymChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"name" => name, "role" => role}, socket) do
    {:ok, assign(socket, :current_user, %{name: name, role: role})}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     TrainingCenterWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
