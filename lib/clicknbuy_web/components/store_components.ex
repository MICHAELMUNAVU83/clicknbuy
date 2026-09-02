defmodule ClicknbuyWeb.StoreComponents do
  @moduledoc """
  Storefront chrome for the Click N Buy shop: the indigo utility bar, the search
  header, the category navigation strip, the newsletter block and the footer.

  These are the pieces that appear on every customer-facing page. Page-specific
  content lives in `ClicknbuyWeb.CatalogComponents`.
  """
  use Phoenix.Component
  use Gettext, backend: ClicknbuyWeb.Gettext

  alias Clicknbuy.SiteSettings

  @support_phone "+254 796 770 862"
  @support_phone_tel "+254796770862"
  @support_email "clicknbuy@gmail.com"

  @doc "Primary storefront navigation links shown in the category strip."
  def nav_links do
    [
      %{label: "Home", href: "/"},
      %{label: "About Us", href: "/about"},
      %{label: "Shop", href: "/collections"},
      %{label: "Contact", href: "/contact"}
    ]
  end

  @doc "Public support contact details, also used by the About/Contact pages."
  def support_phone, do: @support_phone
  def support_phone_tel, do: @support_phone_tel
  def support_email, do: @support_email

  # ---------------------------------------------------------------------------
  # Utility bar
  # ---------------------------------------------------------------------------

  @doc """
  Thin indigo bar above the header carrying shipping promises and a policy link.
  """
  def utility_bar(assigns) do
    ~H"""
    <div class="bg-brand text-white">
      <div class="mx-auto flex max-w-[1500px] items-center justify-between gap-4 px-4 py-2.5 text-[13px] sm:px-6 lg:px-8">
        <div class="flex items-center gap-2 font-medium">
          <svg class="h-4 w-4 shrink-0" fill="none" stroke="currentColor" stroke-width="1.7" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M8.25 18.75a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 01-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 00-3.213-9.193 2.056 2.056 0 00-1.58-.86H14.25M16.5 18.75h-6m0-13.5V14.25m0 0H2.25m13.5 0V5.25a1.5 1.5 0 00-1.5-1.5H3.75a1.5 1.5 0 00-1.5 1.5v9"
            />
          </svg>
          <span class="hidden sm:inline">Free delivery in Nairobi on orders over Ksh 5,000</span>
          <span class="sm:hidden">Free Nairobi delivery over Ksh 5,000</span>
        </div>

        <div class="hidden items-center gap-3 lg:flex">
          <span class="h-4 w-px bg-white/30"></span>
          <p>
            Click N Buy is one of Kenya's fastest-growing stores.
            <.link navigate="/collections" class="font-semibold underline decoration-white/60 underline-offset-2 hover:decoration-white">
              Show all products
            </.link>
          </p>
        </div>

        <.link navigate="/info/returns-exchanges" class="shrink-0 font-semibold hover:underline">
          Privacy Policy
        </.link>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # Header
  # ---------------------------------------------------------------------------

  attr :current_user, :any, default: nil
  attr :query, :string, default: ""

  @doc """
  White header row: wordmark, product search, account link and cart button.
  """
  def store_header(assigns) do
    assigns = assign_new(assigns, :settings, fn -> SiteSettings.get() end)

    ~H"""
    <div class="border-b border-gray-100 bg-white">
      <div class="mx-auto flex max-w-[1500px] items-center gap-4 px-4 py-4 sm:px-6 lg:gap-8 lg:px-8 lg:py-5">
        <%!-- Mobile menu trigger --%>
        <button
          type="button"
          onclick="openStoreMenu()"
          aria-label="Open menu"
          class="-ml-1 rounded-lg p-2 text-ink transition hover:bg-gray-100 lg:hidden"
        >
          <svg class="h-6 w-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
          </svg>
        </button>

        <.wordmark settings={@settings} />

        <%!-- Search --%>
        <form action="/collections" method="get" class="hidden flex-1 lg:block">
          <div class="flex max-w-2xl items-stretch">
            <input
              type="text"
              name="q"
              value={@query}
              placeholder="What are you looking for?"
              aria-label="Search products"
              class="min-w-0 flex-1 rounded-l border border-gray-300 px-4 py-3 text-sm text-ink placeholder-gray-400 transition focus:border-brand focus:outline-none focus:ring-0"
            />
            <button
              type="submit"
              aria-label="Search"
              class="flex w-16 items-center justify-center rounded-r bg-brand text-white transition hover:bg-brand-700"
            >
              <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.2-5.2m2.2-5.3a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z" />
              </svg>
            </button>
          </div>
        </form>

        <div class="ml-auto flex items-center gap-5 sm:gap-7">
          <.account_link current_user={@current_user} />
          <.cart_button />
        </div>
      </div>

      <%!-- Mobile search --%>
      <form action="/collections" method="get" class="px-4 pb-4 sm:px-6 lg:hidden">
        <div class="flex items-stretch">
          <input
            type="text"
            name="q"
            value={@query}
            placeholder="What are you looking for?"
            aria-label="Search products"
            class="min-w-0 flex-1 rounded-l border border-gray-300 px-4 py-2.5 text-sm text-ink placeholder-gray-400 focus:border-brand focus:outline-none"
          />
          <button
            type="submit"
            aria-label="Search"
            class="flex w-12 items-center justify-center rounded-r bg-brand text-white"
          >
            <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2.2" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.2-5.2m2.2-5.3a7.5 7.5 0 11-15 0 7.5 7.5 0 0115 0z" />
            </svg>
          </button>
        </div>
      </form>
    </div>
    """
  end

  attr :settings, :any, required: true

  defp wordmark(assigns) do
    ~H"""
    <.link navigate="/" class="flex shrink-0 items-center gap-2.5">
      <svg class="h-8 w-8 text-brand" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z"
        />
      </svg>
      <span class="font-heading-brand text-xl font-extrabold tracking-tight text-brand sm:text-2xl">
        {@settings.site_name}
      </span>
    </.link>
    """
  end

  attr :current_user, :any, default: nil

  defp account_link(assigns) do
    ~H"""
    <.link
      navigate={if @current_user, do: "/users/settings", else: "/users/log_in"}
      class="group flex items-center gap-2.5 text-ink transition hover:text-brand"
    >
      <svg class="h-7 w-7 shrink-0" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.5 20.25a8.25 8.25 0 0115 0"
        />
      </svg>
      <span class="hidden leading-tight sm:block">
        <span class="block text-[11px] text-gray-400">
          {if @current_user, do: "Signed in", else: "Login"}
        </span>
        <span class="block text-sm font-semibold">
          {if @current_user, do: "Account", else: "Account"}
        </span>
      </span>
    </.link>
    """
  end

  defp cart_button(assigns) do
    ~H"""
    <button
      type="button"
      id="open-cart-drawer"
      aria-label="Open cart"
      class="group flex items-center gap-2.5 text-ink transition hover:text-brand"
    >
      <span class="relative shrink-0">
        <svg class="h-7 w-7" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M15.75 10.5V6a3.75 3.75 0 10-7.5 0v4.5m11.356-1.993l1.263 12A1.125 1.125 0 0119.75 21.75H4.25a1.125 1.125 0 01-1.12-1.243l1.264-12A1.125 1.125 0 015.513 7.5h12.974c.576 0 1.059.435 1.119 1.007z"
          />
        </svg>
        <span
          id="cart-count-badge"
          style="display:none"
          class="absolute -right-2 -top-1.5 flex h-5 min-w-5 items-center justify-center rounded-full bg-accent px-1 text-[11px] font-bold text-white"
        >
          0
        </span>
      </span>
      <span class="hidden text-sm font-semibold sm:block">Your cart</span>
    </button>
    """
  end

  # ---------------------------------------------------------------------------
  # Category navigation strip
  # ---------------------------------------------------------------------------

  attr :collections, :list, default: []
  attr :active, :string, default: nil

  @doc """
  Second header row: the "Browse all categories" dropdown, the main nav links
  and the call/email contact pair.
  """
  def category_nav(assigns) do
    ~H"""
    <div class="hidden border-b border-gray-100 bg-white lg:block">
      <div class="mx-auto flex max-w-[1500px] items-center gap-6 px-4 sm:px-6 lg:px-8">
        <%!-- Browse all categories --%>
        <div class="group relative shrink-0 py-4">
          <button
            type="button"
            class="flex items-center gap-2.5 text-[13px] font-bold uppercase tracking-wide text-ink transition hover:text-brand"
          >
            <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M3.75 6A2.25 2.25 0 016 3.75h2.25A2.25 2.25 0 0110.5 6v2.25a2.25 2.25 0 01-2.25 2.25H6A2.25 2.25 0 013.75 8.25V6zM3.75 15.75A2.25 2.25 0 016 13.5h2.25a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 018.25 20.25H6A2.25 2.25 0 013.75 18v-2.25zM13.5 6a2.25 2.25 0 012.25-2.25H18A2.25 2.25 0 0120.25 6v2.25A2.25 2.25 0 0118 10.5h-2.25A2.25 2.25 0 0113.5 8.25V6zM13.5 15.75a2.25 2.25 0 012.25-2.25H18a2.25 2.25 0 012.25 2.25V18A2.25 2.25 0 0118 20.25h-2.25A2.25 2.25 0 0113.5 18v-2.25z"
              />
            </svg>
            Browse all categories
          </button>

          <%= if @collections != [] do %>
            <div class="invisible absolute left-0 top-full z-40 w-72 translate-y-1 rounded-b-lg border border-gray-100 bg-white py-2 opacity-0 shadow-xl transition-all duration-150 group-hover:visible group-hover:translate-y-0 group-hover:opacity-100">
              <%= for collection <- @collections do %>
                <.link
                  navigate={collection.href}
                  class="flex items-center justify-between px-5 py-2.5 text-sm text-ink transition hover:bg-brand-50 hover:text-brand"
                >
                  {collection.name}
                  <svg class="h-4 w-4 text-gray-300" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
                  </svg>
                </.link>
              <% end %>
            </div>
          <% end %>
        </div>

        <span class="h-6 w-px bg-gray-200"></span>

        <%!-- Main nav --%>
        <nav class="flex items-center gap-7">
          <%= for link <- nav_links() do %>
            <.link
              navigate={link.href}
              class={[
                "py-4 text-[15px] font-semibold transition",
                if(@active == link.label,
                  do: "text-accent",
                  else: "text-ink hover:text-accent"
                )
              ]}
            >
              {link.label}
            </.link>
          <% end %>
        </nav>

        <span class="ml-auto h-6 w-px bg-gray-200"></span>

        <%!-- Contact pair --%>
        <div class="flex shrink-0 items-center gap-6 py-4 text-[15px] font-semibold">
          <a href={"tel:#{support_phone_tel()}"} class="flex items-center gap-2 text-ink transition hover:text-accent">
            <svg class="h-5 w-5 text-accent" fill="none" stroke="currentColor" stroke-width="1.7" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 002.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 01-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 00-1.091-.852H4.5A2.25 2.25 0 002.25 4.5v2.25z"
              />
            </svg>
            Call: {support_phone()}
          </a>
          <a href={"mailto:#{support_email()}"} class="flex items-center gap-2 text-ink transition hover:text-accent">
            <svg class="h-5 w-5 text-accent" fill="none" stroke="currentColor" stroke-width="1.7" viewBox="0 0 24 24">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75"
              />
            </svg>
            <span class="hidden xl:inline">Email: {support_email()}</span>
            <span class="xl:hidden">Email</span>
          </a>
        </div>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # Mobile drawer
  # ---------------------------------------------------------------------------

  attr :collections, :list, default: []

  @doc "Slide-in mobile navigation panel, opened by the header hamburger."
  def mobile_menu(assigns) do
    ~H"""
    <div
      id="store-menu-backdrop"
      onclick="closeStoreMenu()"
      class="pointer-events-none fixed inset-0 z-40 bg-ink/50 opacity-0 backdrop-blur-sm transition-opacity duration-300 lg:hidden"
    >
    </div>

    <div
      id="store-menu-panel"
      style="transform: translateX(-100%);"
      class="fixed left-0 top-0 z-50 flex h-full w-[300px] flex-col bg-white shadow-2xl transition-transform duration-300 ease-out lg:hidden"
    >
      <div class="flex items-center justify-between border-b border-gray-100 px-5 py-4">
        <span class="font-heading-brand text-lg font-extrabold text-brand">Menu</span>
        <button
          type="button"
          onclick="closeStoreMenu()"
          aria-label="Close menu"
          class="rounded-lg p-1.5 text-gray-400 transition hover:bg-gray-100 hover:text-ink"
        >
          <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <nav class="flex-1 overflow-y-auto px-3 py-4">
        <%= for link <- nav_links() do %>
          <.link
            navigate={link.href}
            class="block rounded-lg px-3 py-3 text-sm font-semibold text-ink transition hover:bg-brand-50 hover:text-brand"
          >
            {link.label}
          </.link>
        <% end %>

        <%= if @collections != [] do %>
          <p class="mt-5 px-3 text-[11px] font-bold uppercase tracking-widest text-gray-400">
            Categories
          </p>
          <%= for collection <- @collections do %>
            <.link
              navigate={collection.href}
              class="block rounded-lg px-3 py-2.5 text-sm text-ink transition hover:bg-brand-50 hover:text-brand"
            >
              {collection.name}
            </.link>
          <% end %>
        <% end %>
      </nav>

      <div class="space-y-2 border-t border-gray-100 px-5 py-4 text-sm">
        <a href={"tel:#{support_phone_tel()}"} class="block font-semibold text-ink">
          Call: {support_phone()}
        </a>
        <a href={"mailto:#{support_email()}"} class="block text-gray-500">{support_email()}</a>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # Cart drawer
  # ---------------------------------------------------------------------------

  @doc """
  Right-hand slide-over cart. The body is rendered client-side by the CartHook
  from localStorage, so the element ids here are a contract with `cart_hook.js`.
  """
  def cart_drawer(assigns) do
    ~H"""
    <div
      id="cart-drawer-backdrop"
      onclick="window.CartDrawer && window.CartDrawer.close()"
      class="pointer-events-none fixed inset-0 z-40 bg-ink/40 opacity-0 backdrop-blur-sm transition-opacity duration-300"
    >
    </div>

    <div
      id="cart-drawer"
      style="transform: translateX(100%);"
      class="fixed right-0 top-0 z-50 flex h-full w-full max-w-sm flex-col bg-white shadow-2xl transition-transform duration-300 ease-out"
    >
      <div class="flex items-center justify-between border-b border-gray-100 px-5 py-4">
        <h2 class="font-heading-brand text-base font-bold text-ink">
          Your Cart (<span id="drawer-item-count">0</span>)
        </h2>
        <button
          type="button"
          onclick="window.CartDrawer && window.CartDrawer.close()"
          aria-label="Close cart"
          class="rounded-lg p-1.5 text-gray-400 transition hover:bg-gray-100 hover:text-ink"
        >
          <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <div id="cart-drawer-items" class="flex-1 overflow-y-auto px-5 py-4">
        <div id="cart-drawer-empty" class="flex flex-col items-center justify-center py-16 text-center">
          <svg class="h-14 w-14 text-gray-200" fill="none" stroke="currentColor" stroke-width="1" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M15.75 10.5V6a3.75 3.75 0 10-7.5 0v4.5m11.356-1.993l1.263 12A1.125 1.125 0 0119.75 21.75H4.25a1.125 1.125 0 01-1.12-1.243l1.264-12A1.125 1.125 0 015.513 7.5h12.974c.576 0 1.059.435 1.119 1.007z"
            />
          </svg>
          <p class="mt-4 text-sm font-semibold text-ink">Your cart is empty</p>
          <p class="mt-1 text-xs text-gray-400">Add some items to get started</p>
        </div>
        <div id="cart-drawer-list" class="hidden space-y-4"></div>
      </div>

      <div id="cart-drawer-footer" class="hidden border-t border-gray-100 px-5 py-5">
        <div class="mb-4 flex justify-between text-sm">
          <span class="text-gray-500">Subtotal</span>
          <span class="font-bold text-ink">Ksh <span id="drawer-total">0</span></span>
        </div>
        <a
          href="/checkout"
          class="block w-full rounded bg-accent py-3.5 text-center text-sm font-bold text-white transition hover:bg-accent-600"
        >
          Checkout
        </a>
        <a
          href="/cart"
          class="mt-2.5 block w-full rounded border border-gray-200 py-3.5 text-center text-sm font-semibold text-ink transition hover:border-brand hover:text-brand"
        >
          View Cart
        </a>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # Full chrome wrapper
  # ---------------------------------------------------------------------------

  attr :current_user, :any, default: nil
  attr :collections, :list, default: []
  attr :active, :string, default: nil

  @doc """
  Renders the whole storefront head: cart hook, utility bar, header, category
  nav, mobile drawer and cart drawer. Use this instead of wiring each piece.
  """
  def store_chrome(assigns) do
    ~H"""
    <div id="cart-hook-root" phx-hook="CartHook" class="hidden"></div>
    <.utility_bar />
    <.store_header current_user={@current_user} />
    <.category_nav collections={@collections} active={@active} />
    <.mobile_menu collections={@collections} />
    <.cart_drawer />
    """
  end

  # ---------------------------------------------------------------------------
  # Breadcrumb
  # ---------------------------------------------------------------------------

  attr :crumbs, :list, required: true, doc: "list of %{label:, href:} — last one renders as plain text"

  @doc "Grey breadcrumb strip used on interior pages."
  def breadcrumb(assigns) do
    ~H"""
    <div class="border-b border-gray-100 bg-gray-100">
      <div class="mx-auto flex max-w-[1500px] flex-wrap items-center gap-2 px-4 py-3.5 text-sm sm:px-6 lg:px-8">
        <%= for {crumb, index} <- Enum.with_index(@crumbs) do %>
          <%= if index > 0 do %>
            <span class="text-gray-400">&gt;</span>
          <% end %>
          <%= if crumb[:href] && index < length(@crumbs) - 1 do %>
            <.link navigate={crumb.href} class="text-ink transition hover:text-accent">
              {crumb.label}
            </.link>
          <% else %>
            <span class="font-semibold text-ink">{crumb.label}</span>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # Newsletter
  # ---------------------------------------------------------------------------

  @doc "White newsletter card with an inline email capture form."
  def newsletter(assigns) do
    ~H"""
    <section class="bg-surface px-4 pb-16 sm:px-6 lg:px-8 lg:pb-24">
      <div class="mx-auto max-w-[1500px]">
        <div class="grid items-center gap-8 rounded border border-gray-100 bg-white px-6 py-10 shadow-sm lg:grid-cols-2 lg:px-12 lg:py-14">
          <div>
            <h2 class="font-heading-brand text-2xl font-extrabold text-ink sm:text-3xl">
              Subscribe our newsletter
            </h2>
            <p class="mt-3 max-w-md text-[15px] leading-relaxed text-gray-500">
              Get new arrivals, price drops and members-only deals sent straight to your inbox. No spam —
              unsubscribe any time.
            </p>
          </div>

          <form phx-submit="subscribe_newsletter" class="flex items-stretch">
            <input
              type="email"
              name="email"
              required
              placeholder="Enter your email address"
              aria-label="Email address"
              class="min-w-0 flex-1 rounded-l border border-gray-300 px-4 py-3.5 text-sm text-ink placeholder-gray-400 transition focus:border-brand focus:outline-none"
            />
            <button
              type="submit"
              class="shrink-0 rounded-r bg-accent px-7 py-3.5 text-sm font-bold text-white transition hover:bg-accent-600"
            >
              Subscribe
            </button>
          </form>
        </div>
      </div>
    </section>
    """
  end

  # ---------------------------------------------------------------------------
  # Footer
  # ---------------------------------------------------------------------------

  attr :collections, :list, default: []

  @doc "Dark navy footer with brand blurb, link columns and payment strip."
  def store_footer(assigns) do
    assigns = assign_new(assigns, :settings, fn -> SiteSettings.get() end)

    ~H"""
    <footer class="bg-ink text-white">
      <div class="mx-auto max-w-[1500px] px-4 py-14 sm:px-6 lg:px-8 lg:py-20">
        <div class="grid gap-10 sm:grid-cols-2 lg:grid-cols-4">
          <%!-- Brand --%>
          <div>
            <div class="flex items-center gap-2.5">
              <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z"
                />
              </svg>
              <span class="font-heading-brand text-xl font-extrabold tracking-tight">
                {@settings.site_name}
              </span>
            </div>
            <p class="mt-5 text-sm leading-relaxed text-white/60">
              {@settings.site_tagline}. Quality products at competitive prices, delivered fast across Kenya
              with secure payment on every order.
            </p>
            <div class="mt-6 flex gap-3">
              <.social_icon href={"https://wa.me/#{String.replace(support_phone_tel(), "+", "")}"} label="WhatsApp">
                <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
              </.social_icon>
              <.social_icon href={@settings.instagram_url || "https://instagram.com/clicknbuy"} label="Instagram">
                <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z" />
              </.social_icon>
              <.social_icon href="https://tiktok.com/@clicknbuy" label="TikTok">
                <path d="M12.525.02c1.31-.02 2.61-.01 3.91-.02.08 1.53.63 3.09 1.75 4.17 1.12 1.11 2.7 1.62 4.24 1.79v4.03c-1.44-.05-2.89-.35-4.2-.97-.57-.26-1.1-.59-1.62-.93-.01 2.92.01 5.84-.02 8.75-.08 1.4-.54 2.79-1.35 3.94-1.31 1.92-3.58 3.17-5.91 3.21-1.43.08-2.86-.31-4.08-1.03-2.02-1.19-3.44-3.37-3.65-5.71-.02-.5-.03-1-.01-1.49.18-1.9 1.12-3.72 2.58-4.96 1.66-1.44 3.98-2.13 6.15-1.72.02 1.48-.04 2.96-.04 4.44-.99-.32-2.15-.23-3.02.37-.63.41-1.11 1.04-1.36 1.75-.21.51-.15 1.07-.14 1.61.24 1.64 1.82 3.02 3.5 2.87 1.12-.01 2.19-.66 2.77-1.61.19-.33.4-.67.41-1.06.1-1.79.06-3.57.07-5.36.01-4.03-.01-8.05.02-12.07z" />
              </.social_icon>
            </div>
          </div>

          <%!-- Shop --%>
          <div>
            <h3 class="font-heading-brand text-base font-bold">Shop</h3>
            <ul class="mt-5 space-y-3 text-sm">
              <%= for collection <- Enum.take(@collections, 6) do %>
                <li>
                  <.link navigate={collection.href} class="text-white/60 transition hover:text-white">
                    {collection.name}
                  </.link>
                </li>
              <% end %>
              <li>
                <.link navigate="/collections" class="text-white/60 transition hover:text-white">
                  All Collections
                </.link>
              </li>
            </ul>
          </div>

          <%!-- Customer care --%>
          <div>
            <h3 class="font-heading-brand text-base font-bold">Customer Care</h3>
            <ul class="mt-5 space-y-3 text-sm">
              <%= for {label, href} <- [
                {"How to Order", "/info/how-to-order"},
                {"Shipping & Delivery", "/info/shipping-delivery"},
                {"Returns & Exchanges", "/info/returns-exchanges"},
                {"Warranty & Support", "/info/warranty-support"},
                {"Contact Us", "/contact"},
                {"About Us", "/about"}
              ] do %>
                <li>
                  <.link navigate={href} class="text-white/60 transition hover:text-white">{label}</.link>
                </li>
              <% end %>
            </ul>
          </div>

          <%!-- Get in touch --%>
          <div>
            <h3 class="font-heading-brand text-base font-bold">Get in Touch</h3>
            <ul class="mt-5 space-y-3 text-sm">
              <li class="flex gap-3 text-white/60">
                <svg class="mt-0.5 h-4 w-4 shrink-0" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z" />
                </svg>
                Nairobi, Kenya
              </li>
              <li>
                <a href={"tel:#{support_phone_tel()}"} class="text-white/60 transition hover:text-white">
                  {support_phone()}
                </a>
              </li>
              <li>
                <a href={"mailto:#{support_email()}"} class="text-white/60 transition hover:text-white">
                  {support_email()}
                </a>
              </li>
              <li class="pt-2 text-white/60">
                M-Pesa Till: <strong class="font-semibold text-white">5625020</strong>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <%!-- Payment strip --%>
      <div class="border-t border-white/10">
        <div class="mx-auto flex max-w-[1500px] flex-col items-center gap-4 px-4 py-6 sm:px-6 lg:flex-row lg:justify-between lg:px-8">
          <p class="text-sm text-white/50">
            &copy; {Date.utc_today().year} {@settings.site_name}. All rights reserved.
          </p>
          <div class="flex items-center gap-2.5">
            <span class="mr-1 text-xs font-semibold uppercase tracking-widest text-white/40">
              We accept
            </span>
            <.payment_chip label="M-Pesa" />
            <.payment_chip label="Visa" />
            <.payment_chip label="Mastercard" />
            <.payment_chip label="Paystack" />
          </div>
        </div>
      </div>
    </footer>
    """
  end

  attr :href, :string, required: true
  attr :label, :string, required: true
  slot :inner_block, required: true

  defp social_icon(assigns) do
    ~H"""
    <a
      href={@href}
      target="_blank"
      rel="noopener noreferrer"
      aria-label={@label}
      class="flex h-9 w-9 items-center justify-center rounded-full border border-white/20 text-white/60 transition hover:border-white hover:text-white"
    >
      <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">{render_slot(@inner_block)}</svg>
    </a>
    """
  end

  attr :label, :string, required: true

  defp payment_chip(assigns) do
    ~H"""
    <span class="rounded bg-white/10 px-2.5 py-1.5 text-[11px] font-bold tracking-wide text-white/80">
      {@label}
    </span>
    """
  end

  # ---------------------------------------------------------------------------
  # Floating CTA
  # ---------------------------------------------------------------------------

  @doc "Sticky bottom-right shortcut that opens the cart drawer."
  def floating_cart_cta(assigns) do
    ~H"""
    <button
      type="button"
      id="open-cart-drawer-floating"
      class="fixed bottom-0 right-0 z-30 hidden items-center gap-6 bg-ink px-7 py-4 text-sm font-bold text-white shadow-2xl transition hover:bg-brand lg:flex"
    >
      View cart
      <svg class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
      </svg>
    </button>
    """
  end
end
