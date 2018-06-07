defmodule TrainingCenterWeb.Presence do
  use Phoenix.Presence,
    otp_app: :training_center,
    pubsub_server: TrainingCenter.PubSub
end