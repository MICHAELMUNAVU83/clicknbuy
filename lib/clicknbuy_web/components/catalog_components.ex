defmodule ClicknbuyWeb.CatalogComponents do
  @moduledoc """
  Product-facing building blocks for the storefront: the hero slider, product
  cards, the "Deals of the Week" grid, promo tiles, the tabbed product grid,
  the trust/feature strip, the brand logo row and the testimonial carousel.

  Shared page chrome (header, nav, footer) lives in `ClicknbuyWeb.StoreComponents`.
  """
  use Phoenix.Component
  use Gettext, backend: ClicknbuyWeb.Gettext

  alias ClicknbuyWeb.Format

  # ---------------------------------------------------------------------------
  # Hero
  # ---------------------------------------------------------------------------

  attr :slides, :list, default: []
  attr :current_index, :integer, default: 0

  @doc """
  Full-width indigo hero panel: product shot on the left inside concentric
  rings, headline and CTA on the right, slide dots bottom-right.
  """
  def store_hero(assigns) do
    ~H"""
    <section class="bg-surface px-4 py-6 sm:px-6 lg:px-8 lg:py-10">
      <div class="mx-auto max-w-[1500px]">
        <%= for {slide, index} <- Enum.with_index(@slides) do %>
          <div class={[
            "relative overflow-hidden rounded bg-brand",
            if(index == @current_index, do: "block", else: "hidden")
          ]}>
            <div class="grid items-center gap-8 px-6 py-12 sm:px-10 lg:grid-cols-2 lg:gap-4 lg:px-16 lg:py-20">
              <%!-- Product shot inside concentric rings --%>
              <div class="relative order-1 flex items-center justify-center lg:order-none">
                <div
                  class="pointer-events-none absolute inset-0 z-0 flex items-center justify-center"
                  aria-hidden="true"
                >
                  <span class="absolute h-[330px] w-[330px] rounded-full border border-white/20 sm:h-[540px] sm:w-[540px]">
                  </span>
                  <span class="absolute h-[285px] w-[285px] rounded-full border border-white/20 sm:h-[470px] sm:w-[470px]">
                  </span>
                  <span class="absolute h-[240px] w-[240px] rounded-full border border-white/20 sm:h-[400px] sm:w-[400px]">
                  </span>
                  <span class="absolute h-[195px] w-[195px] rounded-full border border-white/20 sm:h-[330px] sm:w-[330px]">
                  </span>
                  <span class="absolute h-[150px] w-[150px] rounded-full border border-white/20 sm:h-[260px] sm:w-[260px]">
                  </span>
                  <span class="absolute h-[105px] w-[105px] rounded-full border border-white/20 sm:h-[190px] sm:w-[190px]">
                  </span>
                </div>
                <img
                  src={slide.image}
                  alt={slide.title}
                  class="relative z-10 max-h-[260px] w-auto object-contain drop-shadow-2xl sm:max-h-[380px] lg:max-h-[430px]"
                />
              </div>

              <%!-- Copy --%>
              <div class="order-2 text-white lg:order-none">
                <h1 class="font-heading-brand text-3xl font-extrabold leading-[1.1] sm:text-4xl lg:text-5xl xl:text-6xl">
                  {slide.title}
                </h1>
                <p class="mt-5 max-w-lg text-[15px] leading-relaxed text-white/80 sm:text-base">
                  {slide.description}
                </p>
                <.link
                  navigate={slide.href}
                  class="mt-8 inline-flex items-center gap-3 rounded bg-accent px-7 py-3.5 text-sm font-bold text-white transition hover:bg-accent-600"
                >
                  Buy Now
                  <svg
                    class="h-4 w-4"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2.5"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M4.5 12h15m0 0l-6-6m6 6l-6 6"
                    />
                  </svg>
                </.link>
              </div>
            </div>

            <%!-- Slide dots --%>
            <%= if length(@slides) > 1 do %>
              <div class="absolute bottom-0 right-0 flex items-center gap-2.5 rounded-tl-2xl bg-surface px-6 py-4">
                <%= for {_slide, dot_index} <- Enum.with_index(@slides) do %>
                  <button
                    type="button"
                    phx-click="select_hero_slide"
                    phx-value-index={dot_index}
                    aria-label={"Go to slide #{dot_index + 1}"}
                    class={[
                      "h-2.5 w-2.5 rounded-full transition",
                      if(dot_index == @current_index,
                        do: "bg-accent",
                        else: "bg-accent/30 hover:bg-accent/60"
                      )
                    ]}
                  >
                  </button>
                <% end %>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>
    </section>
    """
  end

  # ---------------------------------------------------------------------------
  # Feature / trust strip
  # ---------------------------------------------------------------------------

  @doc "Three white cards under the hero carrying delivery/quality/payment promises."
  def feature_strip(assigns) do
    assigns =
      assign(assigns, :features, [
        %{
          title: "Fast Nairobi delivery",
          body:
            "Same-day dispatch on orders placed before 2pm, countrywide shipping within 2–4 days.",
          icon: :truck
        },
        %{
          title: "Quality assurance",
          body: "Every item is checked before it ships. If it isn't right, we make it right.",
          icon: :badge
        },
        %{
          title: "100% secure payment",
          body: "Pay with M-Pesa or card through Paystack. Your details are never stored.",
          icon: :card
        }
      ])

    ~H"""
    <section class="bg-surface px-4 pb-6 sm:px-6 lg:px-8 lg:pb-10">
      <div class="mx-auto grid max-w-[1500px] gap-5 sm:grid-cols-2 lg:grid-cols-3">
        <%= for feature <- @features do %>
          <div class="flex items-start gap-5 rounded border border-gray-100 bg-white p-7 shadow-sm">
            <span class="shrink-0 text-ink">
              <.feature_icon name={feature.icon} />
            </span>
            <div>
              <h3 class="font-heading-brand text-base font-bold text-ink">{feature.title}</h3>
              <p class="mt-2 text-sm leading-relaxed text-gray-500">{feature.body}</p>
            </div>
          </div>
        <% end %>
      </div>
    </section>
    """
  end

  attr :name, :atom, required: true

  defp feature_icon(%{name: :truck} = assigns) do
    ~H"""
    <svg class="h-10 w-10" fill="none" stroke="currentColor" stroke-width="1.4" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M8.25 18.75a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 01-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 00-3.213-9.193 2.056 2.056 0 00-1.58-.86H14.25M16.5 18.75h-6m0-13.5V14.25m0 0H2.25m13.5 0V5.25a1.5 1.5 0 00-1.5-1.5H3.75a1.5 1.5 0 00-1.5 1.5v9"
      />
    </svg>
    """
  end

  defp feature_icon(%{name: :badge} = assigns) do
    ~H"""
    <svg class="h-10 w-10" fill="none" stroke="currentColor" stroke-width="1.4" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M9 12.75L11.25 15 15 9.75m-3-7.036A11.959 11.959 0 013.598 6 11.99 11.99 0 003 9.749c0 5.592 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751A11.959 11.959 0 0112 2.714z"
      />
    </svg>
    """
  end

  defp feature_icon(%{name: :card} = assigns) do
    ~H"""
    <svg class="h-10 w-10" fill="none" stroke="currentColor" stroke-width="1.4" viewBox="0 0 24 24">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        d="M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3m-3.75 3h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5z"
      />
    </svg>
    """
  end

  # ---------------------------------------------------------------------------
  # Section heading
  # ---------------------------------------------------------------------------

  attr :title, :string, required: true
  attr :view_all_href, :string, default: nil

  @doc "Section title with an optional outlined \"View all\" button and a rule beneath."
  def section_heading(assigns) do
    ~H"""
    <div class="flex flex-wrap items-end justify-between gap-4 border-b border-gray-200 pb-5">
      <h2 class="font-heading-brand text-2xl font-extrabold text-ink sm:text-3xl lg:text-4xl">
        {@title}
      </h2>
      <%= if @view_all_href do %>
        <.link
          navigate={@view_all_href}
          class="inline-flex items-center gap-2.5 rounded border border-accent px-5 py-2.5 text-sm font-semibold text-accent transition hover:bg-accent hover:text-white"
        >
          View all
          <svg
            class="h-4 w-4"
            fill="none"
            stroke="currentColor"
            stroke-width="2.2"
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12h15m0 0l-6-6m6 6l-6 6" />
          </svg>
        </.link>
      <% end %>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # Product card
  # ---------------------------------------------------------------------------

  attr :product, :map, required: true

  attr :context, :string,
    default: "card",
    doc: "disambiguates hook DOM ids when the same product renders in two sections"

  @doc """
  Standard storefront product card: "On Sale" badge, image, name, star rating,
  price with optional struck-through was-price, and an Add to Cart button.
  """
  def product_card(assigns) do
    ~H"""
    <div class="group flex flex-col border border-gray-100 bg-white p-4 transition hover:shadow-lg">
      <.link navigate={"/products/#{@product.slug}"} class="block">
        <div class="relative">
          <%= if @product[:on_sale] do %>
            <span class="absolute left-0 top-0 z-10 rounded-sm bg-brand px-2.5 py-1 text-[11px] font-bold text-white">
              On Sale
            </span>
          <% end %>
          <img
            src={@product.main_image}
            alt={@product.name}
            loading="lazy"
            class="mx-auto aspect-square w-full max-w-[240px] object-contain transition-transform duration-300 group-hover:scale-105"
          />
        </div>

        <h3 class="mt-5 text-center text-[15px] text-ink-400 transition group-hover:text-brand">
          {@product.name}
        </h3>
      </.link>

      <div class="mt-2.5 flex justify-center">
        <.stars value={@product[:rating] || 5} />
      </div>

      <div class="mt-2.5 flex flex-wrap items-center justify-center gap-2">
        <span class="text-[15px] font-bold text-accent">
          Ksh {Format.price(@product.price)}
        </span>
        <%= if @product[:original_price] do %>
          <span class="text-gray-300">|</span>
          <span class="text-sm text-gray-400 line-through">
            Ksh {Format.price(@product.original_price)}
          </span>
        <% end %>
      </div>

      <button
        type="button"
        phx-hook="AddSingleToCart"
        id={"add-to-cart-#{@context}-#{@product.id}"}
        data-product={product_payload(@product)}
        class="mt-5 w-full border border-gray-200 py-3 text-sm font-semibold text-ink transition hover:border-brand hover:bg-brand hover:text-white disabled:opacity-60"
      >
        Add to Cart
      </button>
    </div>
    """
  end

  # JSON payload consumed by the AddSingleToCart JS hook.
  defp product_payload(product) do
    Jason.encode!(%{
      id: product.id,
      name: product.name,
      slug: product.slug,
      price: product.price,
      image: product.main_image
    })
  end

  attr :value, :any, default: 5

  @doc "Five-star rating row. Accepts an integer, float or Decimal."
  def stars(assigns) do
    assigns = assign(assigns, :filled, star_count(assigns.value))

    ~H"""
    <div class="flex items-center gap-0.5" aria-label={"Rated #{@filled} out of 5"}>
      <%= for position <- 1..5 do %>
        <svg
          class={["h-3.5 w-3.5", if(position <= @filled, do: "text-amber-400", else: "text-gray-200")]}
          fill="currentColor"
          viewBox="0 0 20 20"
        >
          <path d="M9.05 2.93c.3-.92 1.6-.92 1.9 0l1.36 4.19h4.4c.97 0 1.37 1.24.59 1.81l-3.56 2.59 1.36 4.18c.3.93-.76 1.7-1.54 1.13L10 14.24l-3.56 2.59c-.78.57-1.84-.2-1.54-1.13l1.36-4.18L2.7 8.93c-.78-.57-.38-1.81.59-1.81h4.4l1.36-4.19z" />
        </svg>
      <% end %>
    </div>
    """
  end

  defp star_count(%Decimal{} = value), do: value |> Decimal.to_float() |> star_count()

  defp star_count(value) when is_float(value),
    do: value |> Float.round() |> trunc() |> star_count()

  defp star_count(value) when is_integer(value), do: value |> max(0) |> min(5)
  defp star_count(_), do: 5

  # ---------------------------------------------------------------------------
  # Product grid sections
  # ---------------------------------------------------------------------------

  attr :title, :string, default: "Deals of the Week"
  attr :products, :list, default: []
  attr :view_all_href, :string, default: "/collections"
  attr :id, :string, default: "deals"

  @doc "Section heading plus a four-across product grid."
  def product_section(assigns) do
    ~H"""
    <section id={@id} class="bg-surface px-4 py-10 sm:px-6 lg:px-8 lg:py-14">
      <div class="mx-auto max-w-[1500px]">
        <.section_heading title={@title} view_all_href={@view_all_href} />

        <%= if @products == [] do %>
          <p class="py-14 text-center text-sm text-gray-400">No products to show yet.</p>
        <% else %>
          <div class="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            <%= for product <- @products do %>
              <.product_card product={product} context={@id} />
            <% end %>
          </div>
        <% end %>
      </div>
    </section>
    """
  end

  attr :tabs, :list, required: true, doc: "list of %{key:, label:, products:}"
  attr :active_tab, :string, required: true
  attr :view_all_href, :string, default: "/collections"

  @doc """
  Tab-filtered product grid — New Arrivals / Ongoing Offers / Featured / Best Sellers.
  Tab switching is a LiveView event so the grid can be re-queried server-side.
  """
  def tabbed_products(assigns) do
    ~H"""
    <section class="bg-surface px-4 py-10 sm:px-6 lg:px-8 lg:py-14">
      <div class="mx-auto max-w-[1500px]">
        <div class="flex flex-wrap items-center justify-between gap-4 border-b border-gray-200 pb-5">
          <div class="flex flex-wrap items-center gap-6">
            <%= for tab <- @tabs do %>
              <button
                type="button"
                phx-click="select_product_tab"
                phx-value-tab={tab.key}
                class={[
                  "text-[15px] font-semibold transition",
                  if(tab.key == @active_tab,
                    do: "text-accent underline decoration-accent decoration-2 underline-offset-8",
                    else: "text-ink hover:text-accent"
                  )
                ]}
              >
                {tab.label}
              </button>
            <% end %>
          </div>

          <.link
            navigate={@view_all_href}
            class="inline-flex items-center gap-2.5 rounded border border-accent px-5 py-2.5 text-sm font-semibold text-accent transition hover:bg-accent hover:text-white"
          >
            View all
            <svg
              class="h-4 w-4"
              fill="none"
              stroke="currentColor"
              stroke-width="2.2"
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12h15m0 0l-6-6m6 6l-6 6" />
            </svg>
          </.link>
        </div>

        <% active = Enum.find(@tabs, &(&1.key == @active_tab)) %>
        <%= if active && active.products != [] do %>
          <div class="mt-8 grid gap-5 sm:grid-cols-2 lg:grid-cols-4">
            <%= for product <- active.products do %>
              <.product_card product={product} context={"tab-#{@active_tab}"} />
            <% end %>
          </div>
        <% else %>
          <p class="py-14 text-center text-sm text-gray-400">Nothing in this list right now.</p>
        <% end %>
      </div>
    </section>
    """
  end

  # ---------------------------------------------------------------------------
  # Promo tiles
  # ---------------------------------------------------------------------------

  attr :tiles, :list, default: [], doc: "list of %{product:, tint:}"

  @doc """
  Two wide promo cards, each with an angled colour panel behind the product shot
  and copy plus a Buy Now button on the right.
  """
  def promo_tiles(assigns) do
    ~H"""
    <%= if @tiles != [] do %>
      <section class="bg-surface px-4 py-6 sm:px-6 lg:px-8 lg:py-10">
        <div class="mx-auto grid max-w-[1560px] gap-5 xl:grid-cols-2 xl:gap-9">
          <%= for tile <- @tiles do %>
            <article class="flex min-h-[320px] flex-col overflow-hidden rounded-md border border-slate-200/80 bg-white shadow-[0_1px_2px_rgba(15,23,42,0.03)] sm:flex-row">
              <%!-- Angled colour panel --%>
              <div class="relative flex min-h-[300px] w-full shrink-0 items-center justify-center overflow-hidden sm:min-h-0 sm:w-[57%]">
                <div class={[
                  "absolute inset-0 sm:[clip-path:polygon(0_0,90%_0,100%_100%,0_100%)]",
                  tile.tint
                ]}>
                </div>
                <img
                  src={tile.product.main_image}
                  alt={tile.product.name}
                  loading="lazy"
                  class="relative z-10 h-[230px] w-[78%] object-contain drop-shadow-xl sm:h-[240px] sm:w-[72%]"
                />
              </div>

              <div class="flex flex-1 flex-col justify-center px-7 py-8 sm:-ml-1 sm:pl-8 sm:pr-6 lg:pl-9">
                <h3 class="font-heading-brand text-lg font-extrabold text-ink lg:text-xl">
                  {tile.product.name}
                </h3>
                <p class="mt-3 line-clamp-3 text-sm leading-7 text-slate-500">
                  {tile.product.description}
                </p>
                <.link
                  navigate={"/products/#{tile.product.slug}"}
                  class="mt-5 inline-flex w-fit items-center gap-3 rounded bg-accent px-5 py-3 text-sm font-bold text-white transition hover:bg-accent-600 focus:outline-none focus:ring-2 focus:ring-accent/40 focus:ring-offset-2"
                >
                  Buy Now
                  <svg
                    class="h-4 w-4"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2.5"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M4.5 12h15m0 0l-6-6m6 6l-6 6"
                    />
                  </svg>
                </.link>
              </div>
            </article>
          <% end %>
        </div>
      </section>
    <% end %>
    """
  end

  # ---------------------------------------------------------------------------
  # Brand logo row
  # ---------------------------------------------------------------------------

  attr :brands, :list, default: nil

  @doc "Muted row of partner/brand wordmarks."
  def brand_row(assigns) do
    assigns =
      assign(
        assigns,
        :brands,
        assigns[:brands] || ["Samsung", "Anker", "JBL", "Xiaomi", "Oraimo", "HP"]
      )

    ~H"""
    <section class="border-y border-gray-100 bg-white px-4 py-12 sm:px-6 lg:px-8">
      <div class="mx-auto flex max-w-[1500px] flex-wrap items-center justify-center gap-x-12 gap-y-6 lg:justify-between">
        <%= for brand <- @brands do %>
          <span class="font-heading-brand text-xl font-extrabold tracking-tight text-ink/25 transition hover:text-ink/50 sm:text-2xl">
            {brand}
          </span>
        <% end %>
      </div>
    </section>
    """
  end

  # ---------------------------------------------------------------------------
  # Product detail
  # ---------------------------------------------------------------------------

  attr :product, :map, required: true
  attr :main_image_index, :integer, default: 0
  attr :selected_color_id, :string, default: nil
  attr :selected_size_id, :string, default: nil
  attr :quantity, :integer, default: 1

  @doc """
  Product detail showcase: bordered gallery with thumbnails on the left, and the
  buy box (title, rating, price, variants, quantity, SKU, share, payment) right.
  """
  def product_showcase(assigns) do
    ~H"""
    <section class="bg-surface px-4 py-8 sm:px-6 lg:px-8 lg:py-12">
      <div class="mx-auto grid max-w-[1500px] gap-8 lg:grid-cols-2 lg:gap-12">
        <%!-- Gallery --%>
        <div>
          <div class="flex items-center justify-center border border-gray-200 bg-white p-8 lg:p-14">
            <img
              src={Enum.at(@product.gallery_images, @main_image_index) || @product.main_image}
              alt={@product.name}
              class="max-h-[420px] w-auto object-contain"
            />
          </div>

          <%= if length(@product.gallery_images) > 1 do %>
            <div class="mt-5 flex flex-wrap gap-4">
              <%= for {image, index} <- Enum.with_index(@product.gallery_images) do %>
                <button
                  type="button"
                  phx-click="set_main_image"
                  phx-value-index={index}
                  aria-label={"View image #{index + 1}"}
                  class={[
                    "flex h-[110px] w-[110px] items-center justify-center border bg-white p-3 transition",
                    if(index == @main_image_index,
                      do: "border-brand ring-1 ring-brand",
                      else: "border-gray-200 hover:border-gray-400"
                    )
                  ]}
                >
                  <img src={image} alt="" class="max-h-full w-auto object-contain" />
                </button>
              <% end %>
            </div>
          <% end %>
        </div>

        <%!-- Buy box --%>
        <div>
          <h1 class="font-heading-brand text-2xl font-extrabold text-ink sm:text-3xl lg:text-4xl">
            {@product.name}
          </h1>

          <div class="mt-4 flex items-center gap-3">
            <.stars value={@product.rating} />
            <%= if @product.reviews_count > 0 do %>
              <span class="text-sm text-gray-400">
                {@product.reviews_count} review{if @product.reviews_count == 1, do: "", else: "s"}
              </span>
            <% end %>
          </div>

          <div class="mt-5 flex flex-wrap items-center gap-3">
            <span class="text-2xl font-extrabold text-accent sm:text-3xl">
              Ksh {Format.price(@product.price)}
            </span>
            <%= if @product[:original_price] do %>
              <span class="text-gray-300">|</span>
              <span class="text-lg text-gray-400 line-through">
                Ksh {Format.price(@product.original_price)}
              </span>
            <% end %>
          </div>

          <hr class="my-6 border-gray-200" />

          <p class="text-[15px] leading-relaxed text-gray-500">{@product.description}</p>

          <%!-- Colour --%>
          <%= if @product.colors != [] do %>
            <div class="mt-7">
              <p class="text-sm font-semibold text-ink">Colour</p>
              <div class="mt-3 flex flex-wrap gap-3">
                <%= for color <- @product.colors do %>
                  <button
                    type="button"
                    phx-click="select_color"
                    phx-value-id={color.id}
                    title={color.name}
                    aria-label={color.name}
                    class={[
                      "h-9 w-9 rounded-full border-2 transition",
                      if(color.id == @selected_color_id,
                        do: "border-ink ring-2 ring-ink/20 ring-offset-2",
                        else: "border-gray-200 hover:border-gray-400"
                      )
                    ]}
                    style={"background-color: #{color.hex};"}
                  >
                  </button>
                <% end %>
              </div>
            </div>
          <% end %>

          <%!-- Size / variant axis — hidden when there's only one option, so
               single-SKU electronics don't show a lone "Standard" button --%>
          <%= if length(@product.sizes) > 1 do %>
            <div class="mt-6">
              <p class="text-sm font-semibold text-ink">Size</p>
              <div class="mt-3 flex flex-wrap gap-2.5">
                <%= for size <- @product.sizes do %>
                  <button
                    type="button"
                    phx-click="select_size"
                    phx-value-name={size.name}
                    disabled={!size.available}
                    class={[
                      "min-w-[52px] border px-4 py-2.5 text-sm font-semibold transition",
                      cond do
                        !size.available ->
                          "cursor-not-allowed border-gray-100 text-gray-300 line-through"

                        size.name == @selected_size_id ->
                          "border-brand bg-brand text-white"

                        true ->
                          "border-gray-200 text-ink hover:border-brand hover:text-brand"
                      end
                    ]}
                  >
                    {size.name}
                  </button>
                <% end %>
              </div>
            </div>
          <% end %>

          <%!-- Quantity + add to cart --%>
          <div class="mt-8 flex flex-wrap items-stretch gap-4">
            <div class="flex items-center border border-gray-200 bg-white">
              <button
                type="button"
                phx-click="set_quantity"
                phx-value-quantity={max(@quantity - 1, 1)}
                aria-label="Decrease quantity"
                class="px-4 py-3.5 text-lg text-gray-400 transition hover:text-ink"
              >
                −
              </button>
              <span class="w-10 text-center text-sm font-semibold text-ink">{@quantity}</span>
              <button
                type="button"
                phx-click="set_quantity"
                phx-value-quantity={min(@quantity + 1, 99)}
                aria-label="Increase quantity"
                class="px-4 py-3.5 text-lg text-gray-400 transition hover:text-ink"
              >
                +
              </button>
            </div>

            <button
              type="button"
              phx-click="add_to_cart"
              class="flex-1 border border-gray-200 bg-white px-8 py-3.5 text-sm font-bold text-ink transition hover:border-accent hover:bg-accent hover:text-white sm:flex-none"
            >
              Add to Cart
            </button>
          </div>

          <hr class="my-7 border-gray-200" />

          <dl class="space-y-4 text-sm">
            <div class="flex gap-6">
              <dt class="w-28 shrink-0 font-bold text-ink">SKU:</dt>
              <dd class="text-gray-500">{@product.sku}</dd>
            </div>
            <div class="flex gap-6">
              <dt class="w-28 shrink-0 font-bold text-ink">Category:</dt>
              <dd class="text-gray-500">{@product.product_type}</dd>
            </div>
            <div class="flex items-center gap-6">
              <dt class="w-28 shrink-0 font-bold text-ink">Share:</dt>
              <dd class="flex items-center gap-3">
                <.share_link
                  href={"https://www.facebook.com/sharer/sharer.php?u=#{share_url(@product.slug)}"}
                  label="Share on Facebook"
                  class="text-[#1877F2]"
                >
                  <path d="M22 12a10 10 0 10-11.56 9.88v-6.99H7.9V12h2.54V9.8c0-2.5 1.49-3.89 3.77-3.89 1.09 0 2.23.2 2.23.2v2.46h-1.26c-1.24 0-1.63.77-1.63 1.56V12h2.78l-.45 2.89h-2.33v6.99A10 10 0 0022 12z" />
                </.share_link>
                <.share_link
                  href={"https://twitter.com/intent/tweet?url=#{share_url(@product.slug)}"}
                  label="Share on X"
                  class="text-[#1DA1F2]"
                >
                  <path d="M22.46 6c-.77.35-1.6.58-2.46.69a4.3 4.3 0 001.88-2.37 8.6 8.6 0 01-2.72 1.04 4.28 4.28 0 00-7.29 3.9A12.14 12.14 0 013 4.79a4.28 4.28 0 001.32 5.71c-.7-.02-1.37-.22-1.95-.54v.05a4.28 4.28 0 003.43 4.2 4.3 4.3 0 01-1.93.07 4.28 4.28 0 004 2.97A8.6 8.6 0 012 19.54a12.1 12.1 0 006.56 1.92c7.88 0 12.2-6.53 12.2-12.19v-.56A8.7 8.7 0 0022.46 6z" />
                </.share_link>
                <.share_link
                  href={"https://pinterest.com/pin/create/button/?url=#{share_url(@product.slug)}"}
                  label="Share on Pinterest"
                  class="text-[#E60023]"
                >
                  <path d="M12 2a10 10 0 00-3.65 19.31c-.02-.5 0-1.1.13-1.65l1.06-4.48s-.26-.53-.26-1.31c0-1.23.71-2.15 1.6-2.15.76 0 1.12.57 1.12 1.25 0 .76-.48 1.9-.74 2.96-.21.88.45 1.6 1.32 1.6 1.58 0 2.65-2.03 2.65-4.44 0-1.83-1.23-3.2-3.48-3.2-2.53 0-4.11 1.89-4.11 4a2.4 2.4 0 00.5 1.58c.1.12.11.17.08.31l-.22.87c-.04.14-.15.19-.28.13-.79-.32-1.28-1.48-1.28-2.38 0-1.94 1.41-4.72 5.42-4.72 3.16 0 5.24 2.29 5.24 4.75 0 3.25-1.8 5.68-4.47 5.68-.9 0-1.74-.48-2.03-1.03l-.55 2.14c-.2.75-.73 1.68-1.1 2.25A10 10 0 1012 2z" />
                </.share_link>
              </dd>
            </div>
          </dl>

          <hr class="my-7 border-gray-200" />

          <div class="flex flex-wrap items-center gap-6">
            <p class="text-sm font-bold text-ink">Payment Method:</p>
            <div class="flex flex-wrap items-center gap-2.5">
              <%= for method <- ["M-Pesa", "Visa", "Mastercard", "Paystack"] do %>
                <span class="border border-gray-200 bg-white px-3 py-2 text-[11px] font-bold tracking-wide text-gray-500">
                  {method}
                </span>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  defp share_url(slug), do: URI.encode_www_form("https://clicknbuy.com/products/#{slug}")

  attr :href, :string, required: true
  attr :label, :string, required: true
  attr :class, :string, default: ""
  slot :inner_block, required: true

  defp share_link(assigns) do
    ~H"""
    <a
      href={@href}
      target="_blank"
      rel="noopener noreferrer"
      aria-label={@label}
      class={["transition hover:opacity-70", @class]}
    >
      <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 24 24">{render_slot(@inner_block)}</svg>
    </a>
    """
  end

  attr :product, :map, required: true
  attr :active_tab, :string, default: "description"

  @doc """
  "Description" / "Additional information" tab pair beneath the product showcase.
  """
  def product_info_tabs(assigns) do
    ~H"""
    <section class="bg-surface px-4 pb-10 sm:px-6 lg:px-8 lg:pb-14">
      <div class="mx-auto max-w-[1500px]">
        <div class="flex flex-wrap gap-1 border-b border-gray-200">
          <%= for {key, label} <- [{"description", "Description"}, {"additional", "Additional information"}] do %>
            <button
              type="button"
              phx-click="select_info_tab"
              phx-value-tab={key}
              class={[
                "-mb-px border px-6 py-3.5 text-sm font-semibold transition",
                if(key == @active_tab,
                  do: "border-gray-200 border-b-white bg-white text-accent",
                  else: "border-transparent text-ink hover:text-accent"
                )
              ]}
            >
              {label}
            </button>
          <% end %>
        </div>

        <div class="border border-t-0 border-gray-200 bg-white p-7 lg:p-10">
          <%= if @active_tab == "description" do %>
            <div class="max-w-4xl space-y-4 text-[15px] leading-relaxed text-gray-500">
              <p>{@product.description}</p>
              <%= if @product.size_advice not in [nil, ""] do %>
                <p>{@product.size_advice}</p>
              <% end %>
            </div>
          <% else %>
            <dl class="max-w-2xl divide-y divide-gray-100 text-sm">
              <.spec_row label="SKU" value={@product.sku} />
              <.spec_row label="Category" value={@product.product_type} />
              <%= if @product.colors != [] do %>
                <.spec_row label="Colours" value={Enum.map_join(@product.colors, ", ", & &1.name)} />
              <% end %>
              <%= if @product.sizes != [] do %>
                <.spec_row label="Sizes" value={Enum.map_join(@product.sizes, ", ", & &1.name)} />
              <% end %>
              <%= if @product.shipping_returns not in [nil, ""] do %>
                <.spec_row label="Shipping & returns" value={@product.shipping_returns} />
              <% end %>
            </dl>
          <% end %>
        </div>
      </div>
    </section>
    """
  end

  attr :label, :string, required: true
  attr :value, :string, required: true

  defp spec_row(assigns) do
    ~H"""
    <div class="flex flex-col gap-1 py-3.5 sm:flex-row sm:gap-8">
      <dt class="w-48 shrink-0 font-bold text-ink">{@label}</dt>
      <dd class="text-gray-500">{@value}</dd>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # Testimonials
  # ---------------------------------------------------------------------------

  attr :testimonials, :list, default: []
  attr :current_index, :integer, default: 0

  @doc "Indigo testimonial card with avatar, quote and prev/next controls."
  def testimonial_carousel(assigns) do
    ~H"""
    <%= if @testimonials != [] do %>
      <section class="bg-surface px-4 py-10 sm:px-6 lg:px-8 lg:py-16">
        <div class="mx-auto max-w-[1500px]">
          <% count = length(@testimonials) %>
          <% index = rem(rem(@current_index, count) + count, count) %>
          <% testimonial = Enum.at(@testimonials, index) %>

          <div class="relative overflow-hidden rounded bg-brand px-6 py-14 sm:px-16 lg:px-24 lg:py-20">
            <%= if count > 1 do %>
              <button
                type="button"
                phx-click="prev_testimonial"
                aria-label="Previous testimonial"
                class="absolute left-3 top-1/2 z-10 flex h-11 w-11 -translate-y-1/2 items-center justify-center rounded-full bg-accent text-white transition hover:bg-accent-600 sm:left-6 sm:h-12 sm:w-12"
              >
                <svg
                  class="h-5 w-5"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2.5"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M19.5 12h-15m0 0l6 6m-6-6l6-6"
                  />
                </svg>
              </button>
              <button
                type="button"
                phx-click="next_testimonial"
                aria-label="Next testimonial"
                class="absolute right-3 top-1/2 z-10 flex h-11 w-11 -translate-y-1/2 items-center justify-center rounded-full bg-accent text-white transition hover:bg-accent-600 sm:right-6 sm:h-12 sm:w-12"
              >
                <svg
                  class="h-5 w-5"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2.5"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M4.5 12h15m0 0l-6-6m6 6l-6 6"
                  />
                </svg>
              </button>
            <% end %>

            <div class="mx-auto max-w-3xl text-center text-white">
              <%= if testimonial[:avatar] do %>
                <img
                  src={testimonial.avatar}
                  alt={testimonial.name}
                  class="mx-auto h-20 w-20 rounded-full object-cover ring-4 ring-white/20"
                />
              <% else %>
                <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-white/15 text-2xl font-bold ring-4 ring-white/20">
                  {String.first(testimonial.name || "?")}
                </div>
              <% end %>

              <p class="mt-6 font-heading-brand text-base font-bold">{testimonial.name}</p>

              <blockquote class="mt-5 text-[15px] leading-relaxed text-white/85 sm:text-base">
                {testimonial.content}
              </blockquote>

              <svg class="mx-auto mt-8 h-8 w-8 text-white/70" fill="currentColor" viewBox="0 0 24 24">
                <path d="M7.17 6A5.17 5.17 0 002 11.17V18h6.83v-6.83H5.17A2 2 0 017.17 9V6zm10 0A5.17 5.17 0 0012 11.17V18h6.83v-6.83h-3.66a2 2 0 012-2.17V6z" />
              </svg>
            </div>
          </div>
        </div>
      </section>
    <% end %>
    """
  end
end
