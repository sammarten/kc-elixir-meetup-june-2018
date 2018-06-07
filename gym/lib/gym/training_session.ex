defmodule Gym.TrainingSession do
  alias Gym.Workout

  def start_training_session() do
    workout_template = Workout.get_workout_template()
    initial_status(workout_template)
  end

  def get_participant_status(status, name) do
    # status.participant_workouts[name_to_key(name)]
    status.participant_workouts[name]
  end

  def add_participant(status, name) do
    if participant_does_not_exist(status, name) do
      create_participant_entry(status, name)
    else
      status
    end
  end

  def participant_does_not_exist(status, name) do
    is_nil(get_participant_status(status, name))
  end

  def create_participant_entry(status, name) do
    participants = [name | status.participants]

    participant_workouts =
      Map.put(
        status.participant_workouts,
        # name_to_key(name),
        name,
        generate_new_participant_workout(status.workout_template)
      )

    status
    |> Map.put(:participants, participants)
    |> Map.put(:participant_workouts, participant_workouts)
  end

  def complete_exercise(status, name, exercise) do
    # participant_workout_key = name_to_key(name)
    participant_workout_key = name

    updated_workout =
      status.participant_workouts
      |> Map.get(participant_workout_key)
      |> find_and_complete_exercise(exercise)

    put_in(status, [:participant_workouts, participant_workout_key], updated_workout)
  end

  # Helpers

  def find_and_complete_exercise(workout, exercise) when is_list(workout) do
    workout
    |> Enum.map(fn entry ->
      case entry.name == exercise do
        true -> Map.put(entry, :complete, "true")
        false -> entry
      end
    end)
  end

  def generate_new_participant_workout(workout_template) do
    workout_template
    |> Enum.map(fn {sequence, exercise} ->
      %{sequence: sequence, name: exercise, complete: "false"}
    end)
  end

  def initial_status(workout_template) do
    %{
      workout_template: workout_template,
      participants: [],
      participant_workouts: %{}
    }
  end

  def name_to_key(name) when is_binary(name) do
    name
    |> String.trim()
    |> String.downcase()
    |> String.replace(" ", "_", global: true)
    |> String.to_atom()
  end
end
