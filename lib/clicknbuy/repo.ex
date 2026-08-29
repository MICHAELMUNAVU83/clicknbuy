defmodule Clicknbuy.Repo do
  use Ecto.Repo,
    otp_app: :clicknbuy,
    adapter: Ecto.Adapters.Postgres
end
