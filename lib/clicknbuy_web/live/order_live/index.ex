defmodule ClicknbuyWeb.OrderLive.Index do
  use ClicknbuyWeb, :admin_live_view

  alias ClicknbuyWeb.AdminTheme

  alias Clicknbuy.Orders

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Orders")
     |> assign(:current_path, "/admin/orders")
     |> assign(:counts, %{pending_orders: Orders.count_pending()})
     |> assign(:status_filter, "all")
     |> assign(:search, "")
     |> assign(:status_counts, Orders.count_by_status())
     |> assign(:orders, Orders.list_orders_filtered("all", ""))}
  end

  @impl true
  def handle_event("filter_status", %{"status" => status}, socket) do
    orders = Orders.list_orders_filtered(status, socket.assigns.search)

    {:noreply,
     socket
     |> assign(:status_filter, status)
     |> assign(:orders, orders)}
  end

  @impl true
  def handle_event("search", params, socket) do
    q = Map.get(params, "value", Map.get(params, "q", ""))
    orders = Orders.list_orders_filtered(socket.assigns.status_filter, q)
    {:noreply, socket |> assign(:search, q) |> assign(:orders, orders)}
  end

  @impl true
  def handle_event("update_status", %{"id" => id, "status" => status}, socket) do
    order = Orders.get_order!(id)

    case Orders.update_status(order, status) do
      {:ok, updated_order} ->
        orders =
          socket.assigns.orders
          |> Enum.map(fn o -> if o.id == updated_order.id, do: updated_order, else: o end)

        {:noreply,
         socket
         |> assign(:orders, orders)
         |> assign(:status_counts, Orders.count_by_status())
         |> assign(:counts, %{pending_orders: Orders.count_pending()})}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Could not update order status.")}
    end
  end

  # ── Helpers ───────────────────────────────────────────────────────────────

  defp status_color(status), do: AdminTheme.status_pill(status)

  defp status_dot(status), do: AdminTheme.status_dot(status)

  defp next_statuses(current) do
    flow = %{
      "paid" => ["processing", "shipped", "cancelled"],
      "processing" => ["shipped", "cancelled"],
      "shipped" => ["delivered", "cancelled"],
      "delivered" => [],
      "cancelled" => [],
      "failed" => ["paid"]
    }

    Map.get(flow, current, [])
  end

  defp fmt(n), do: ClicknbuyWeb.Format.price(n)

  defp format_date(dt) do
    Calendar.strftime(dt, "%d %b %Y, %H:%M")
  end

  defp item_count(items) when is_list(items) do
    Enum.reduce(items, 0, fn i, acc -> acc + (i["quantity"] || 1) end)
  end

  defp item_count(_), do: 0

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">

      <!-- ── Page banner ── -->
      <div class="relative overflow-hidden rounded-xl bg-gradient-to-r from-brand-600 to-ink px-7 py-6 text-white shadow-md">
        <div class="pointer-events-none absolute -right-8 -top-8 h-32 w-32 rounded-full bg-white/5"></div>
        <div class="pointer-events-none absolute bottom-0 right-20 h-20 w-20 rounded-full bg-white/5"></div>
        <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <p class="text-xs font-medium uppercase tracking-widest text-brand-200">Commerce</p>
            <h1 class="mt-0.5 font-heading-brand text-2xl font-bold">Orders</h1>
            <p class="mt-1 text-xs text-brand-200">{Map.get(@status_counts, "all", 0)} confirmed orders in total</p>
          </div>
          <!-- Search -->
          <div class="relative flex-shrink-0">
            <svg class="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-white/50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
            <input
              type="text"
              name="q"
              placeholder="Search reference, name, email…"
              value={@search}
              phx-change="search"
              phx-debounce="250"
              class="w-72 rounded-xl border border-white/20 bg-white/10 py-2.5 pl-10 pr-9 text-sm text-white placeholder-white/50 backdrop-blur-sm focus:border-white/50 focus:outline-none focus:ring-2 focus:ring-white/20"
            />
            <%= if @search != "" do %>
              <button phx-click="search" phx-value-value="" class="absolute right-3 top-1/2 -translate-y-1/2 text-white/50 hover:text-white">
                <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
              </button>
            <% end %>
          </div>
        </div>
      </div>

      <!-- Summary cards -->
      <div class="grid grid-cols-2 gap-4 sm:grid-cols-4">
        <%= for {status, label, icon} <- [
          {"paid",       "Paid",       "💳"},
          {"processing", "Processing", "⚙️"},
          {"shipped",    "Shipped",    "🚚"},
          {"delivered",  "Delivered",  "✅"}
        ] do %>
          <% {accent, val_class} = AdminTheme.status_tile(status) %>
          <button
            phx-click="filter_status"
            phx-value-status={status}
            class={[
              "group overflow-hidden rounded-xl border p-5 text-left shadow-sm transition hover:shadow-md",
              if(@status_filter == status,
                do: "ring-2 ring-brand ring-offset-1 " <> accent,
                else: "bg-white border-gray-100 hover:border-brand/20"
              )
            ]}
          >
            <div class="flex items-center justify-between">
              <p class="text-xs font-semibold uppercase tracking-widest text-gray-500">{label}</p>
              <span class="text-lg">{icon}</span>
            </div>
            <p class={["mt-2 font-heading-brand text-3xl font-bold tabular-nums", val_class]}>
              {Map.get(@status_counts, status, 0)}
            </p>
          </button>
        <% end %>
      </div>

      <!-- Status Tabs -->
      <div class="flex gap-1 overflow-x-auto rounded-lg border border-gray-100 bg-white p-1.5 shadow-sm">
        <%= for {key, label} <- [{"all","All"},{"paid","Paid"},{"processing","Processing"},{"shipped","Shipped"},{"delivered","Delivered"},{"cancelled","Cancelled"},{"failed","Failed"}] do %>
          <% count = Map.get(@status_counts, key, 0) %>
          <button
            phx-click="filter_status"
            phx-value-status={key}
            class={[
              "flex items-center gap-1.5 whitespace-nowrap rounded-xl px-3.5 py-1.5 text-xs font-semibold transition",
              if(@status_filter == key,
                do: "bg-brand text-white shadow-sm",
                else: "text-gray-500 hover:bg-brand/10 hover:text-brand"
              )
            ]}
          >
            {label}
            <%= if count > 0 do %>
              <span class={[
                "rounded-full px-1.5 py-0.5 text-[10px] font-bold tabular-nums",
                if(@status_filter == key, do: "bg-white/20 text-white", else: "bg-gray-100 text-gray-500")
              ]}>{count}</span>
            <% end %>
          </button>
        <% end %>
      </div>

      <!-- Orders Table -->
      <div class="overflow-hidden rounded-xl border border-gray-100 bg-white shadow-sm">
        <%= if @orders == [] do %>
          <div class="flex flex-col items-center justify-center py-20 text-center">
            <span class="text-5xl">🛍️</span>
            <p class="mt-4 text-sm font-medium text-gray-500">No orders found</p>
            <p class="mt-1 text-xs text-gray-500">Try changing the filter or search term.</p>
          </div>
        <% else %>
          <div class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="border-b border-gray-100 bg-gray-50/80">
                  <th class="px-5 py-3.5 text-left text-[11px] font-semibold uppercase tracking-wider text-gray-500">Reference</th>
                  <th class="px-5 py-3.5 text-left text-[11px] font-semibold uppercase tracking-wider text-gray-500">Customer</th>
                  <th class="px-5 py-3.5 text-left text-[11px] font-semibold uppercase tracking-wider text-gray-500">Items</th>
                  <th class="px-5 py-3.5 text-left text-[11px] font-semibold uppercase tracking-wider text-gray-500">Total</th>
                  <th class="px-5 py-3.5 text-left text-[11px] font-semibold uppercase tracking-wider text-gray-500">Status</th>
                  <th class="px-5 py-3.5 text-left text-[11px] font-semibold uppercase tracking-wider text-gray-500">Date</th>
                  <th class="px-5 py-3.5 text-right text-[11px] font-semibold uppercase tracking-wider text-gray-500">Actions</th>
                </tr>
              </thead>
              <tbody>
                <%= for order <- @orders do %>
                  <tr
                    class="group border-b border-gray-100 transition-colors last:border-0 hover:bg-brand/5 cursor-pointer"
                    phx-click={JS.navigate("/admin/orders/#{order.id}")}
                  >
                    <td class="px-5 py-3.5">
                      <span class="font-mono text-xs font-semibold text-ink">{order.reference}</span>
                    </td>
                    <td class="px-5 py-3.5">
                      <div class="flex items-center gap-2.5">
                        <div class="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-brand/10 text-xs font-bold text-brand">
                          {order.name |> String.split() |> Enum.take(2) |> Enum.map(&String.first/1) |> Enum.join()}
                        </div>
                        <div>
                          <p class="text-sm font-medium text-ink">{order.name}</p>
                          <p class="text-xs text-gray-500">{order.email}</p>
                        </div>
                      </div>
                    </td>
                    <td class="px-5 py-3.5">
                      <% count = item_count(order.items) %>
                      <span class="rounded-full bg-gray-100 px-2.5 py-0.5 text-xs font-medium text-gray-600">
                        {count} {if count == 1, do: "item", else: "items"}
                      </span>
                    </td>
                    <td class="px-5 py-3.5">
                      <span class="text-sm font-bold text-ink">KES {fmt(order.total_amount)}</span>
                    </td>
                    <td class="px-5 py-3.5">
                      <span class={["inline-flex items-center gap-1.5 rounded-full px-2.5 py-1 text-[11px] font-semibold capitalize", status_color(order.status)]}>
                        <span class={["h-1.5 w-1.5 rounded-full", status_dot(order.status)]} />
                        {order.status}
                      </span>
                    </td>
                    <td class="px-5 py-3.5">
                      <span class="text-xs text-gray-500">{format_date(order.inserted_at)}</span>
                    </td>
                    <td class="px-5 py-3.5" phx-click="">
                      <div class="flex items-center justify-end gap-1 opacity-0 transition-opacity group-hover:opacity-100">
                        <%= for next <- next_statuses(order.status) do %>
                          <button
                            phx-click="update_status"
                            phx-value-id={order.id}
                            phx-value-status={next}
                            class="rounded-lg border border-brand/30 bg-brand/5 px-2.5 py-1 text-[10px] font-semibold capitalize text-brand transition hover:bg-brand hover:text-white"
                          >→ {next}</button>
                        <% end %>
                        <.link navigate={"/admin/orders/#{order.id}"}
                          class="flex h-8 w-8 items-center justify-center rounded-lg border border-gray-200 text-gray-500 transition hover:border-brand/30 hover:text-brand">
                          <svg class="h-3.5 w-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                          </svg>
                        </.link>
                      </div>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        <% end %>
      </div>

    </div>
    """
  end
end
