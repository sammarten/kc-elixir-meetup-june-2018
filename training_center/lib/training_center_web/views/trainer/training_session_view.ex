defmodule TrainingCenterWeb.Trainer.TrainingSessionView do
  use TrainingCenterWeb, :view

  alias __MODULE__, as: TrainingSessionView
  alias TrainingCenterWeb.JavascriptView

  def get_html(status, presence_list) do
    Phoenix.View.render_to_string(TrainingSessionView, "in_progress.html", status: status, presence: presence_list)
  end

  def get_exercise_status_class(workout_status, exercise) do
    case exercise_complete?(workout_status, exercise) do
      false -> "exercise-tracker-not-complete"
      true -> "exercise-tracker-complete"
    end
  end

  def exercise_complete?(workout_status, exercise) do
    case find_exercise(workout_status, exercise) do
      nil -> false
      entry ->
        entry.complete == "true"
    end
  end

  def find_exercise(workout_status, exercise) do
    Enum.find(workout_status, nil, fn entry -> entry.name == exercise end)
  end

  def online_status(presence_list, name) do
    if presence_list[name] != nil, do: "online", else: "offline"
  end

  def page_javascript(_conn, _action, _assigns) do
    JavascriptView.connect_to_channel()
  end
end
