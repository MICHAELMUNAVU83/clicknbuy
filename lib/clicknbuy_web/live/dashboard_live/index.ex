defmodule ClicknbuyWeb.DashboardLive.Index do
  use ClicknbuyWeb, :admin_live_view

  alias ClicknbuyWeb.AdminTheme

  alias Clicknbuy.Orders
  alias Clicknbuy.Customers
  alias Clicknbuy.Repo
  alias Clicknbuy.Products.Product
  alias Clicknbuy.Collections.Collection

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Dashboard")
     |> assign(:current_path, "/admin")
     |> load_stats()
     |> load_charts()}
  end

  # ── Data loading ──────────────────────────────────────────────────────────

  defp load_stats(socket) do
    status_counts = Orders.count_by_status()

    socket
    |> assign(:total_revenue, Orders.total_revenue())
    |> assign(:total_orders, Orders.total_orders())
    |> assign(:total_customers, Customers.count_customers())
    |> assign(:avg_order_value, Orders.average_order_value())
    |> assign(:total_products, Repo.aggregate(Product, :count))
    |> assign(:total_collections, Repo.aggregate(Collection, :count))
    |> assign(:status_counts, status_counts)
    |> assign(:recent_orders, Orders.recent_orders(5))
  end

  defp load_charts(socket) do
    daily = Orders.daily_revenue(30)
    top_products = Orders.top_products_by_revenue(6)
    status_counts = socket.assigns.status_counts

    socket
    |> assign(:revenue_chart, build_revenue_chart(daily))
    |> assign(:status_chart, build_status_chart(status_counts))
    |> assign(:top_products_chart, build_top_products_chart(top_products))
  end

  # ── Chart palette ─────────────────────────────────────────────────────────
  #
  # Mirrors the storefront tokens in `assets/css/app.css`: indigo is structural,
  # red is the accent, navy is ink. The order-status ramp below is *ordinal* —
  # the four pipeline stages read light → dark as an order progresses, while the
  # two terminal states sit outside the ramp (neutral for cancelled, accent red
  # for failed) so they never impersonate a stage.
  @brand "#2F32CE"
  @brand_fill "rgba(47,50,206,0.08)"
  @ink "#122554"
  @grid "#E8ECF8"
  @axis_muted "#7286AE"
  @axis_ink "#2C4272"

  @status_colors %{
    "paid" => "#9fa3fb",
    "processing" => "#5558e6",
    "shipped" => "#2427A5",
    "delivered" => "#101340",
    "cancelled" => "#64748b",
    "failed" => "#DB4A44"
  }

  @statuses ~w(paid processing shipped delivered cancelled failed)

  # ── Chart builders ────────────────────────────────────────────────────────

  defp build_revenue_chart(daily) do
    labels = Enum.map(daily, fn {d, _} -> Calendar.strftime(d, "%d %b") end)
    values = Enum.map(daily, fn {_, v} -> v end)

    %{
      data: %{
        labels: labels,
        datasets: [
          %{
            label: "Revenue",
            data: values,
            borderColor: @brand,
            backgroundColor: @brand_fill,
            fill: true,
            tension: 0.35,
            pointRadius: 0,
            pointHoverRadius: 4.5,
            pointHoverBackgroundColor: @brand,
            pointHoverBorderColor: "#ffffff",
            pointHoverBorderWidth: 2,
            borderWidth: 2
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        interaction: %{mode: "index", intersect: false},
        plugins: %{
          legend: %{display: false},
          tooltip: %{
            backgroundColor: @ink,
            titleFont: %{size: 11},
            bodyFont: %{size: 12, weight: "bold"},
            padding: 10,
            cornerRadius: 6,
            displayColors: false
          }
        },
        scales: %{
          x: %{
            grid: %{display: false},
            border: %{display: false},
            ticks: %{font: %{size: 10}, color: @axis_muted, maxTicksLimit: 7}
          },
          y: %{
            grid: %{color: @grid},
            border: %{display: false, dash: [4, 4]},
            ticks: %{font: %{size: 10}, color: @axis_muted},
            beginAtZero: true
          }
        }
      }
    }
    |> Jason.encode!()
  end

  defp build_status_chart(status_counts) do
    labels = Enum.map(@statuses, &String.capitalize/1)
    values = Enum.map(@statuses, &Map.get(status_counts, &1, 0))

    %{
      data: %{
        labels: labels,
        datasets: [
          %{
            data: values,
            backgroundColor: Enum.map(@statuses, &Map.fetch!(@status_colors, &1)),
            # 2px surface gap between adjacent segments
            borderColor: "#ffffff",
            borderWidth: 2,
            hoverOffset: 8
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        cutout: "72%",
        plugins: %{
          # The legend lives in the markup as a labelled value list, so slices
          # are never identified by colour alone.
          legend: %{display: false},
          tooltip: %{
            backgroundColor: @ink,
            padding: 10,
            cornerRadius: 6
          }
        }
      }
    }
    |> Jason.encode!()
  end

  defp build_top_products_chart(products) do
    labels = Enum.map(products, & &1.name)
    values = Enum.map(products, & &1.revenue)

    %{
      data: %{
        labels: labels,
        datasets: [
          %{
            label: "Revenue",
            # One measure, one series — bar length already encodes magnitude,
            # so every bar wears the same brand hue rather than a rank ramp.
            data: values,
            backgroundColor: @brand,
            borderRadius: 4,
            barThickness: 14
          }
        ]
      },
      options: %{
        responsive: true,
        maintainAspectRatio: false,
        indexAxis: "y",
        plugins: %{
          legend: %{display: false},
          tooltip: %{
            backgroundColor: @ink,
            padding: 10,
            cornerRadius: 6,
            displayColors: false
          }
        },
        scales: %{
          x: %{
            grid: %{color: @grid},
            border: %{display: false},
            ticks: %{font: %{size: 10}, color: @axis_muted}
          },
          y: %{
            grid: %{display: false},
            border: %{display: false},
            ticks: %{font: %{size: 11}, color: @axis_ink}
          }
        }
      }
    }
    |> Jason.encode!()
  end

  # ── Helpers ───────────────────────────────────────────────────────────────

  defp fmt(n), do: ClicknbuyWeb.Format.price(n)

  # Chips reuse the doughnut's ramp, so a status reads the same colour on every
  # admin screen.
  defp status_pill(status), do: AdminTheme.status_pill(status)
  defp status_dot(status), do: AdminTheme.status_dot(status)

  defp format_date(dt), do: Calendar.strftime(dt, "%d %b %Y, %H:%M")

  defp greeting do
    # rough EAT offset
    hour = DateTime.utc_now().hour + 3

    cond do
      hour < 12 -> "Good morning"
      hour < 17 -> "Good afternoon"
      true -> "Good evening"
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-7">
      
    <!-- ── Hero greeting banner ── -->
      <div class="relative overflow-hidden rounded-xl bg-gradient-to-br from-brand-600 via-brand-700 to-ink p-7 text-white shadow-lg">
        <!-- Decorative circles -->
        <div class="pointer-events-none absolute -right-12 -top-12 h-48 w-48 rounded-full bg-white/5">
        </div>
        <div class="pointer-events-none absolute -bottom-10 -right-4 h-32 w-32 rounded-full bg-white/5">
        </div>
        <div class="pointer-events-none absolute bottom-4 right-40 h-16 w-16 rounded-full bg-white/10">
        </div>

        <div class="relative flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <p class="text-sm font-medium text-brand-200">{greeting()}, welcome back ✨</p>
            <h1 class="mt-1 font-heading-brand text-3xl font-bold tracking-tight">
              ClicknBuy
            </h1>
            <p class="mt-2 text-sm text-brand-200 max-w-xs">
              Here's what's happening in your store today. Fashion .
            </p>
          </div>
          
    <!-- Revenue highlight -->
          <div class="flex-shrink-0 rounded-lg bg-white/10 px-6 py-4 backdrop-blur-sm border border-white/20">
            <p class="text-xs font-semibold uppercase tracking-widest text-brand-200">Total Revenue</p>
            <p class="mt-1 font-heading-brand text-3xl font-bold tabular-nums">
              KES {@total_revenue |> fmt()}
            </p>
            <p class="mt-1 text-xs text-brand-200">
              {@total_orders} confirmed {if @total_orders == 1, do: "order", else: "orders"}
            </p>
          </div>
        </div>
      </div>
      
    <!-- ── KPI cards ── -->
      <div class="grid grid-cols-2 gap-4 lg:grid-cols-4">
        <.kpi_card
          label="Orders"
          value={to_string(@total_orders)}
          sub="confirmed"
          icon="🛍️"
          accent="bg-brand-50 border-brand-100"
          value_class="text-brand-700"
        />
        <.kpi_card
          label="Customers"
          value={to_string(@total_customers)}
          sub="unique buyers"
          icon="👥"
          accent="bg-surface-200 border-ink-200"
          value_class="text-ink"
        />
        <.kpi_card
          label="Avg. Order"
          value={"KES #{fmt(@avg_order_value)}"}
          sub="per transaction"
          icon="💎"
          accent="bg-accent-50 border-accent-100"
          value_class="text-accent-700"
        />
        <.kpi_card
          label="Products"
          value={to_string(@total_products)}
          sub={"#{@total_collections} collections"}
          icon="👗"
          accent="bg-white border-gray-200"
          value_class="text-ink"
        />
      </div>
      
    <!-- ── Charts row ── -->
      <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        
    <!-- Revenue chart — 2/3 -->
        <div class="lg:col-span-2 overflow-hidden rounded-xl border border-gray-100 bg-white shadow-sm">
          <div class="flex items-center justify-between border-b border-gray-50 px-6 py-5">
            <div>
              <h2 class="font-heading-brand text-base font-semibold text-ink">Revenue Trend</h2>
              <p class="text-xs text-gray-500">Last 30 days · confirmed orders only</p>
            </div>
            <span class="rounded-full bg-brand/10 px-3 py-1 text-xs font-semibold text-brand">
              KES {fmt(@total_revenue)}
            </span>
          </div>
          <div class="px-6 pb-6 pt-2">
            <div class="h-52">
              <canvas
                id="revenue-chart"
                phx-hook="ChartHook"
                data-type="line"
                data-chart={@revenue_chart}
              />
            </div>
          </div>
        </div>
        
    <!-- Status doughnut — 1/3 -->
        <div class="overflow-hidden rounded-xl border border-gray-100 bg-white shadow-sm">
          <div class="border-b border-gray-50 px-6 py-5">
            <h2 class="font-heading-brand text-base font-semibold text-ink">Orders by Status</h2>
            <p class="text-xs text-gray-500">Distribution breakdown</p>
          </div>
          <div class="px-6 pb-5 pt-2">
            <div class="h-44">
              <canvas
                id="status-chart"
                phx-hook="ChartHook"
                data-type="doughnut"
                data-chart={@status_chart}
              />
            </div>
            <%!-- Labelled legend: identity is never carried by colour alone. --%>
            <dl class="mt-4 grid grid-cols-2 gap-x-4 gap-y-1.5">
              <%= for status <- ~w(paid processing shipped delivered cancelled failed) do %>
                <div class="flex items-center gap-2 text-[11px]">
                  <span class={["h-2 w-2 shrink-0 rounded-full", status_dot(status)]} />
                  <dt class="capitalize text-gray-500">{status}</dt>
                  <dd class="ml-auto font-semibold tabular-nums text-ink">
                    {Map.get(@status_counts, status, 0)}
                  </dd>
                </div>
              <% end %>
            </dl>
          </div>
        </div>
      </div>
      
    <!-- ── Bottom row ── -->
      <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        
    <!-- Top products — 2/3 -->
        <div class="lg:col-span-2 overflow-hidden rounded-xl border border-gray-100 bg-white shadow-sm">
          <div class="flex items-center justify-between border-b border-gray-50 px-6 py-5">
            <div>
              <h2 class="font-heading-brand text-base font-semibold text-ink">Best-Selling Products</h2>
              <p class="text-xs text-gray-500">By total revenue across all orders</p>
            </div>
            <.link
              navigate="/admin/products"
              class="text-xs font-semibold text-brand hover:underline"
            >
              Browse all →
            </.link>
          </div>
          <div class="px-6 pb-6 pt-2">
            <div class="h-56">
              <canvas
                id="top-products-chart"
                phx-hook="ChartHook"
                data-type="bar"
                data-chart={@top_products_chart}
              />
            </div>
          </div>
        </div>
        
    <!-- Recent orders — 1/3 -->
        <div class="overflow-hidden rounded-xl border border-gray-100 bg-white shadow-sm">
          <div class="flex items-center justify-between border-b border-gray-50 px-5 py-5">
            <h2 class="font-heading-brand text-base font-semibold text-ink">Recent Orders</h2>
            <.link
              navigate="/admin/orders"
              class="text-xs font-semibold text-brand hover:underline"
            >
              View all →
            </.link>
          </div>

          <div class="divide-y divide-gray-50">
            <%= if @recent_orders == [] do %>
              <div class="flex flex-col items-center py-12 text-center">
                <span class="text-4xl">🛍️</span>
                <p class="mt-3 text-sm text-gray-500">No orders yet</p>
              </div>
            <% else %>
              <%= for order <- @recent_orders do %>
                <.link
                  navigate={"/admin/orders/#{order.id}"}
                  class="flex items-center gap-3 px-5 py-3.5 transition hover:bg-gray-50/80"
                >
                  <!-- Avatar initials -->
                  <div class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-brand/10 text-xs font-bold text-brand">
                    {order.name
                    |> String.split()
                    |> Enum.take(2)
                    |> Enum.map(&String.first/1)
                    |> Enum.join()}
                  </div>
                  <div class="min-w-0 flex-1">
                    <p class="truncate text-xs font-semibold text-ink">{order.name}</p>
                    <p class="truncate font-mono text-[10px] text-gray-500">{order.reference}</p>
                  </div>
                  <div class="text-right flex-shrink-0">
                    <p class="text-xs font-bold text-ink">KES {fmt(order.total_amount)}</p>
                    <span class={[
                      "inline-flex items-center gap-1 rounded-full px-1.5 py-0.5 text-[9px] font-semibold capitalize",
                      status_pill(order.status)
                    ]}>
                      <span class={["h-1 w-1 rounded-full", status_dot(order.status)]} />
                      {order.status}
                    </span>
                  </div>
                </.link>
              <% end %>
            <% end %>
          </div>

          <%= if @recent_orders != [] do %>
            <div class="border-t border-gray-50 px-5 py-3 text-center">
              <p class="text-[10px] text-gray-500">
                Last order: {format_date(List.first(@recent_orders).inserted_at)}
              </p>
            </div>
          <% end %>
        </div>
      </div>
      
    <!-- ── Status pills + Quick actions ── -->
      <div class="grid grid-cols-1 gap-6 lg:grid-cols-2">
        
    <!-- Status mini-tiles -->
        <div class="overflow-hidden rounded-xl border border-gray-100 bg-white p-5 shadow-sm">
          <h2 class="mb-4 font-heading-brand text-base font-semibold text-ink">Order Pipeline</h2>
          <div class="grid grid-cols-3 gap-3">
            <%= for {status, label, icon} <- [
              {"paid",       "Paid",       "💳"},
              {"processing", "Processing", "⚙️"},
              {"shipped",    "Shipped",    "🚚"},
              {"delivered",  "Delivered",  "✅"},
              {"cancelled",  "Cancelled",  "✕"},
              {"failed",     "Failed",     "⚠️"}
            ] do %>
              <.link
                navigate="/admin/orders"
                class="group flex flex-col items-center rounded-lg border border-gray-100 bg-gray-50/60 p-3 text-center transition hover:border-brand/30 hover:bg-brand/5"
              >
                <span class="text-xl">{icon}</span>
                <span class="mt-1 text-lg font-bold tabular-nums text-ink">
                  {Map.get(@status_counts, status, 0)}
                </span>
                <span class="text-[10px] font-medium text-gray-500 uppercase tracking-wide">
                  {label}
                </span>
              </.link>
            <% end %>
          </div>
        </div>
        
    <!-- Quick actions -->
        <div class="overflow-hidden rounded-xl border border-gray-100 bg-white p-5 shadow-sm">
          <h2 class="mb-4 font-heading-brand text-base font-semibold text-ink">Quick Actions</h2>
          <div class="grid grid-cols-2 gap-3">
            <.link
              navigate="/admin/orders"
              class="group flex items-center gap-3 rounded-lg border border-gray-100 bg-gray-50/60 p-4 transition hover:border-brand/30 hover:bg-brand/5"
            >
              <span class="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-lg bg-brand/10 text-lg group-hover:bg-brand/20 transition">
                🛍️
              </span>
              <div>
                <p class="text-sm font-semibold text-ink">Orders</p>
                <p class="text-xs text-gray-500">{Map.get(@status_counts, "all", 0)} total</p>
              </div>
            </.link>

            <.link
              navigate="/admin/customers"
              class="group flex items-center gap-3 rounded-lg border border-gray-100 bg-gray-50/60 p-4 transition hover:border-brand/30 hover:bg-brand/5"
            >
              <span class="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-lg bg-ink-100 text-lg group-hover:bg-ink-200 transition">
                👥
              </span>
              <div>
                <p class="text-sm font-semibold text-ink">Customers</p>
                <p class="text-xs text-gray-500">{@total_customers} buyers</p>
              </div>
            </.link>

            <.link
              navigate="/admin/products"
              class="group flex items-center gap-3 rounded-lg border border-gray-100 bg-gray-50/60 p-4 transition hover:border-brand/30 hover:bg-brand/5"
            >
              <span class="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-lg bg-brand-100 text-lg group-hover:bg-brand-200 transition">
                👗
              </span>
              <div>
                <p class="text-sm font-semibold text-ink">Products</p>
                <p class="text-xs text-gray-500">{@total_products} items</p>
              </div>
            </.link>

            <.link
              navigate="/admin/promotions"
              class="group flex items-center gap-3 rounded-lg border border-gray-100 bg-gray-50/60 p-4 transition hover:border-brand/30 hover:bg-brand/5"
            >
              <span class="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-lg bg-accent-100 text-lg group-hover:bg-accent-200 transition">
                🏷️
              </span>
              <div>
                <p class="text-sm font-semibold text-ink">Promo Codes</p>
                <p class="text-xs text-gray-500">Influencer campaigns</p>
              </div>
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # ── Sub-components ────────────────────────────────────────────────────────

  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :sub, :string, default: ""
  attr :icon, :string, default: "✦"
  attr :accent, :string, default: "bg-gray-50 border-gray-100"
  attr :value_class, :string, default: "text-ink"

  defp kpi_card(assigns) do
    ~H"""
    <div class={["overflow-hidden rounded-xl border p-5 shadow-sm", @accent]}>
      <div class="flex items-start justify-between">
        <p class="text-xs font-semibold uppercase tracking-widest text-gray-500">{@label}</p>
        <span class="text-xl leading-none">{@icon}</span>
      </div>
      <p class={["mt-3 font-heading-brand text-2xl font-bold tabular-nums", @value_class]}>{@value}</p>
      <p class="mt-1 text-xs text-gray-500">{@sub}</p>
    </div>
    """
  end
end
