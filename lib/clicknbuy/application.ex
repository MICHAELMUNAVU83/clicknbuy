defmodule Clicknbuy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ClicknbuyWeb.Telemetry,
      Clicknbuy.Repo,
      {DNSCluster, query: Application.get_env(:clicknbuy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Clicknbuy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Clicknbuy.Finch},
      # Site settings cache (loads once from DB, invalidated on save)
      {Clicknbuy.SiteSettings, []},
      # Start to serve requests, typically the last entry
      ClicknbuyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Clicknbuy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ClicknbuyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
