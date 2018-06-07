defmodule TrainingCenterWeb.LayoutView do
  use TrainingCenterWeb, :view

  def page_javascript(conn, assigns) do
    try do
      apply(view_module(conn), :page_javascript, [conn, action_name(conn), assigns])
    rescue
      UndefinedFunctionError ->
        ""
    end
  end
end
