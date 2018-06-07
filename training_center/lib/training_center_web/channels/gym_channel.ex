defmodule TrainingCenterWeb.GymChannel do
  use Phoenix.Channel

  alias TrainingCenterWeb.Presence
  alias TrainingCenterWeb.TrainingSessionView
  alias TrainingCenterWeb.Trainer

  intercept [
    "training_session_started", 
    "training_session_ended",
    "status_updated",
    "presence_diff"
  ]

  def join("training_session:" <> training_session_id, _, socket) do
    send(self(), :after_join)
    {:ok, assign(socket, :training_session_id, training_session_id)}
  end

  def handle_info(:after_join, socket) do
    case role(socket) do
      "participant" ->
        push_participant_status(socket)
      "trainer" ->
        push_status(socket)
    end

    push_presence_state(socket)

    {:ok, _} = track_presence(socket)

    {:noreply, socket}
  end

  def handle_in("complete_exercise", %{"name" => name}, socket) do
    # could add training_session_in_progress? check here
    status = Gym.complete_exercise(training_session_id(socket), current_user(socket).name, name)
    push(socket, "participant_status", %{html: TrainingSessionView.get_html(status)})
    broadcast!(socket, "status_updated", %{})
    {:noreply, socket}
  end

  def handle_out("training_session_started", _msg, socket) do
    if is_participant?(socket) do
      status = Gym.get_participant_status(training_session_id(socket), current_user(socket).name)
      push(socket, "participant_status", %{html: TrainingSessionView.get_html(status)})
    end
    {:noreply, socket}
  end

  def handle_out("training_session_ended", _msg, socket) do
    if is_participant?(socket) do
      status = :not_started
      push(socket, "participant_status", %{html: TrainingSessionView.get_html(status)})
    end
    {:noreply, socket}
  end

  def handle_out("status_updated", _msg, socket) do
    if is_trainer?(socket), do: push_status(socket)
    {:noreply, socket}
  end

  def handle_out("presence_diff", _msg, socket) do
    if is_trainer?(socket), do: push_status(socket)
    {:noreply, socket}    
  end

  def push_participant_status(socket) do
    status =
      if training_session_in_progress?(training_session_id(socket)) do
        Gym.get_participant_status(training_session_id(socket), current_user(socket).name)    
      else
        :not_started
      end
    push(socket, "participant_status", %{html: TrainingSessionView.get_html(status)})
    broadcast!(socket, "status_updated", %{})
  end

  def push_status(socket) do
    status = Gym.get_status(training_session_id(socket))
    presence_list = get_presence_list(socket)
    push(socket, "status_updated", %{html: Trainer.TrainingSessionView.get_html(status, presence_list)})
  end

  def push_presence_state(socket) do
    push(socket, "presence_state", Presence.list(socket))
  end

  def get_presence_list(socket) do
    Presence.list(socket)
  end

  def track_presence(socket) do
    Presence.track(socket, current_user(socket).name, %{
      online_at: inspect(System.system_time(:seconds))
    })
  end

  def training_session_in_progress?(training_session_id) do
    case Process.whereis(:"training_session:#{training_session_id}") do
      nil -> false
      pid when is_pid(pid) -> true
    end
  end

  def current_user(socket), do: socket.assigns.current_user

  def training_session_id(socket), do: socket.assigns.training_session_id

  def is_participant?(socket), do: role(socket) == "participant"

  def is_trainer?(socket), do: role(socket) == "trainer"

  def role(socket), do: current_user(socket).role
end
