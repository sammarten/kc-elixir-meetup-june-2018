defmodule Gym do
  alias Gym.Server

  def start_training_session(id) do
    case Server.start(id) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def stop_training_session(id) do
    Server.stop(id)
  end

  def get_participant_status(id, name) do
    GenServer.call(get_pid(id), {:get_participant_status, name})
  end

  def complete_exercise(id, name, exercise) do
    GenServer.call(get_pid(id), {:complete_exercise, name, exercise})
  end

  def get_status(id) do
    GenServer.call(get_pid(id), {:get_status})
  end

  defp get_pid(id), do: Server.get_name(id)

  # def get_training_session_status(id) do    
  # end
end
