defmodule TrainingCenterWeb.JavascriptView do
  use TrainingCenterWeb, :view

  def connect_to_channel() do
    "<script>require('js/app').GymChannel.connect()</script>"
  end
end