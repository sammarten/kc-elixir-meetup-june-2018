defmodule TrainingCenterWeb.Router do
  use TrainingCenterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TrainingCenterWeb do
    pipe_through :browser # Use the default browser stack

    get "/", HomeController, :index

    resources "/home", HomeController, only: [:index]
    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
    resources "/training_sessions", TrainingSessionController, only: [:show]
  end

  scope "/trainer", TrainingCenterWeb.Trainer, as: :trainer do
    pipe_through :browser # Use the default browser stack

    resources "/home", HomeController, only: [:index]
    post "/training_sessions/:id/start", TrainingSessionController, :start_training_session
    post "/training_sessions/:id/stop", TrainingSessionController, :stop_training_session
    resources "/training_sessions", TrainingSessionController, only: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrainingCenterWeb do
  #   pipe_through :api
  # end
end
