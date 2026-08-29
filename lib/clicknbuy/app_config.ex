defmodule Clicknbuy.AppConfig do
  @moduledoc """
  Runtime application configuration helpers.

  Values are read from the application environment at call time so they
  reflect whatever is set in config/runtime.exs or overridden by env vars.
  """

  @doc """
  Returns the public site URL (no trailing slash).

  Configurable via:
    - `config :clicknbuy, site_url: \"https://clicknbuy.com\"` in config files
    - `SITE_URL` environment variable at runtime (prod)
  """
  def site_url do
    Application.get_env(:clicknbuy, :site_url, "https://clicknbuy.com")
    |> String.trim_trailing("/")
  end

  @doc """
  Returns the admin email address for order notifications.

  Configurable via:
    - `config :clicknbuy, admin_email: \"...\"` in config files
    - `ADMIN_EMAIL` environment variable at runtime (prod)
  """
  def admin_email do
    Application.get_env(:clicknbuy, :admin_email, "clicknbuy@gmail.com")
  end
end
