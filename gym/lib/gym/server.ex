defmodule Gym.Server do
  use GenServer

  alias Gym.TrainingSession

  def start(id) do
    IO.puts "Starting Trainining Session #{id}"
    GenServer.start(__MODULE__, nil, name: get_name(id))
  end

  def stop(id) do
    id
    |> get_name()
    |> GenServer.stop()
  end

  def init(_) do
    {:ok, TrainingSession.start_training_session()}
  end

  def handle_call({:get_participant_status, name}, _from, status) do
    updated_status = TrainingSession.add_participant(status, name)

    participant_status = TrainingSession.get_participant_status(updated_status, name)

    {:reply, participant_status, updated_status}
  end

  def handle_call({:complete_exercise, name, exercise}, _from, status) do
    updated_status = TrainingSession.complete_exercise(status, name, exercise)

    participant_status = TrainingSession.get_participant_status(updated_status, name)

    {:reply, participant_status, updated_status}
  end

  def handle_call({:get_status}, _from, status) do
    {:reply, status, status}
  end

  # Helpers

  def get_name(id) do
    :"training_session:#{id}"
  end
end
