defmodule ClicknbuyWeb.CollectionsLive.Index do
  use ClicknbuyWeb, :live_view

  alias Clicknbuy.Shop

  @impl true
  def mount(_params, _session, socket) do
    collections = Shop.list_collections_for_display()

    {:ok,
     socket
     |> assign(:page_title, "All Collections")
     |> assign(:collections, collections)}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    query = params |> Map.get("q", "") |> to_string() |> String.trim()

    {:noreply,
     socket
     |> assign(:query, query)
     |> assign(:results, Shop.search_products(query))
     |> assign(
       :page_title,
       if(query == "", do: "All Collections", else: "Search: #{query}")
     )}
  end

  @impl true
  def handle_event("subscribe_newsletter", _params, socket) do
    {:noreply, put_flash(socket, :info, "Thanks for subscribing! Watch your inbox for new deals.")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-surface">
      <.store_chrome current_user={@current_user} collections={@collections} active="Shop" />

      <.breadcrumb crumbs={
        if @query == "",
          do: [%{label: "Home", href: "/"}, %{label: "Shop"}],
          else: [
            %{label: "Home", href: "/"},
            %{label: "Shop", href: "/collections"},
            %{label: "Search: #{@query}"}
          ]
      } />

      <%= if @query != "" do %>
        <%!-- Search results --%>
        <section class="px-4 py-10 sm:px-6 lg:px-8 lg:py-14">
          <div class="mx-auto max-w-[1500px]">
            <h1 class="font-heading-brand text-2xl font-extrabold text-ink sm:text-3xl lg:text-4xl">
              Results for "{@query}"
            </h1>
            <p class="mt-3 text-sm text-gray-500">
              {length(@results)} product{if length(@results) == 1, do: "", else: "s"} found.
            </p>

            <%= if @results == [] do %>
              <div class="mt-10 border border-gray-100 bg-white px-6 py-20 text-center">
                <p class="font-heading-brand text-lg font-bold text-ink">Nothing matched that search</p>
                <p class="mx-auto mt-2 max-w-md text-sm text-gray-500">
                  Try a shorter or more general term, or browse the collections below.
                </p>
                <.link
                  navigate="/collections"
                  class="mt-7 inline-flex items-center gap-2.5 rounded bg-accent px-6 py-3 text-sm font-bold text-white transition hover:bg-accent-600"
                >
                  Browse all collections
                </.link>
              </div>
            <% else %>
              <div class="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
                <%= for product <- @results do %>
                  <.product_card product={product} context="search" />
                <% end %>
              </div>
            <% end %>
          </div>
        </section>
      <% else %>

      <%!-- Hero strip --%>
      <div class="bg-white">
        <div class="mx-auto max-w-[1500px] px-4 py-12 sm:px-6 lg:px-8">
          <p class="text-xs font-bold uppercase tracking-widest text-accent">
            Browse the store
          </p>
          <h1 class="mt-2 font-heading-brand text-3xl font-extrabold text-ink sm:text-4xl lg:text-5xl">
            All Collections
          </h1>
          <p class="mt-3 text-sm text-gray-500">
            {length(@collections)} collections — find what you're looking for.
          </p>
        </div>
      </div>

      <%!-- Collections grid --%>
      <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div class="grid gap-5 w-[100%] sm:grid-cols-2 lg:grid-cols-3">
          <%= for {collection, index} <- Enum.with_index(@collections, 1) do %>
            <a
              href={collection.href}
              class="group relative overflow-hidden rounded-2xl bg-gray-100 transition hover:shadow-xl"
            >
              <%!-- Cover image --%>
              <%= if collection.image not in [nil, ""] do %>
                <img
                  src={collection.image}
                  alt={collection.name}
                  class="aspect-[4/3] w-full object-cover object-top transition-transform duration-500 group-hover:scale-105"
                />
              <% else %>
                <div class="aspect-[4/3] w-full bg-gradient-to-br from-gray-200 to-gray-300 flex items-center justify-center">
                  <span class="text-5xl opacity-30">👗</span>
                </div>
              <% end %>

              <%!-- Gradient overlay --%>
              <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />

              <%!-- Text --%>
              <div class="absolute inset-x-0 bottom-0 p-5">
                <span class="text-xs font-semibold text-white/50">
                  {String.pad_leading("#{index}", 2, "0")}
                </span>
                <h2 class="mt-1 text-xl font-bold text-white leading-tight">{collection.name}</h2>
                <div class="mt-2 flex items-center justify-between">
                  <span class="text-xs text-white/70">{collection.item_count} items</span>
                  <span class="inline-flex items-center gap-1 rounded-full bg-white/20 px-3 py-1 text-xs font-semibold text-white backdrop-blur-sm transition group-hover:bg-[#C8001F]">
                    Shop
                    <svg
                      class="h-3 w-3 transition-transform group-hover:translate-x-0.5"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M17 8l4 4m0 0l-4 4m4-4H3"
                      />
                    </svg>
                  </span>
                </div>
              </div>
            </a>
          <% end %>
        </div>

        <%= if @collections == [] do %>
          <div class="flex flex-col items-center justify-center py-24 text-center">
            <p class="mt-4 font-heading-brand text-lg font-bold text-ink">No collections yet</p>
            <p class="mt-1 text-sm text-gray-400">Check back soon — new stock lands monthly.</p>
          </div>
        <% end %>
      </div>
      <% end %>

      <.newsletter />
      <.store_footer collections={@collections} />
      <.floating_cart_cta />
    </div>
    """
  end
end
