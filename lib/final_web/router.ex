defmodule FinalWeb.Router do
  use FinalWeb, :router

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

  scope "/", FinalWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/transactions", TransactionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", FinalWeb do
  #   pipe_through :api
  # end
end
