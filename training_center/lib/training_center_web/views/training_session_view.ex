defmodule TrainingCenterWeb.TrainingSessionView do
  use TrainingCenterWeb, :view

  alias __MODULE__, as: TrainingSessionView
  alias TrainingCenterWeb.JavascriptView

  def get_html(:not_started) do
    Phoenix.View.render_to_string(TrainingSessionView, "not_started.html", [])
  end

  def get_html(status) do
    Phoenix.View.render_to_string(TrainingSessionView, "in_progress.html", status: status)
  end

  def page_javascript(_conn, _action, _assigns) do
    JavascriptView.connect_to_channel()
  end
end
