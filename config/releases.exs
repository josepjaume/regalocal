# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :regalocal, Regalocal.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :regalocal, Regalocal.Veil,
  request_salt: System.get_env("VEIL_REQUEST_SALT"),
  session_salt: System.get_env("VEIL_SESSION_SALT")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

review_app_host =
  if System.get_env("HEROKU_APP_NAME") do
    "#{System.get_env("HEROKU_APP_NAME")}.herokuapp.com"
  end

host = System.get_env("HOST") || review_app_host || "example.com"

config :regalocal, RegalocalWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  url: [host: host, scheme: "https"],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :regalocal, RegalocalWeb.Endpoint, server: true

config :veil,
  email_from_address: System.get_env("EMAIL") || "regalocal@#{host}"

#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

config :veil, RegalocalWeb.Veil.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: "smtp.sendgrid.net",
  username: System.get_env("SENDGRID_USERNAME"),
  password: System.get_env("SENDGRID_PASSWORD"),
  ssl: true,
  auth: :always,
  port: 465,
  retries: 2
