defmodule RegalocalWeb.Router do
  use RegalocalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RegalocalWeb.Plugs.Veil.BusinessId
    plug RegalocalWeb.Plugs.Veil.Business
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RegalocalWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RegalocalWeb do
  #   pipe_through :api
  # end

  # Default Routes for Veil
  scope "/auth", RegalocalWeb.Veil do
    pipe_through(:browser)

    post("/businesses", BusinessController, :create, as: :veil_business)
    get("/businesses/new", BusinessController, :new, as: :veil_business)

    get("/sessions/new/:request_id", SessionController, :create)
    get("/sessions/signout/:session_id", SessionController, :delete)
  end

  # Add your routes that require authentication in this block.
  # Alternatively, you can use the default block and authenticate in the controllers.
  # See the Veil README for more.
  scope "/profile", RegalocalWeb.Profile, as: :profile do
    pipe_through([:browser, RegalocalWeb.Plugs.Veil.Authenticate])

    get("/business", BusinessController, :show)
    get("/business/edit", BusinessController, :edit)
    put("/business", BusinessController, :update)
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
    end
  end
end
