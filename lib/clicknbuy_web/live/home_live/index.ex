defmodule ClicknbuyWeb.HomeLive.Index do
  use ClicknbuyWeb, :live_view

  alias Clicknbuy.Shop

  # Alternating tints behind the two promo tiles.
  @promo_tints ["bg-indigo-400", "bg-rose-300"]

  @impl true
  def mount(_params, _session, socket) do
    collections = Shop.list_collections_for_display()
    new_arrivals = Shop.list_new_arrivals()
    bestsellers = Shop.list_bestsellers()
    featured = Shop.list_bundle_display_products()
    all_products = Shop.list_products_for_display()

    on_sale = Enum.filter(all_products, & &1.on_sale)

    {:ok,
     socket
     |> assign(:page_title, "Shop Smart, Buy Fast")
     |> assign(:collections, collections)
     |> assign(:hero_slides, build_hero_slides(featured, all_products))
     |> assign(:hero_index, 0)
     |> assign(:deals, Enum.take(if(on_sale == [], do: all_products, else: on_sale), 4))
     |> assign(:promo_tiles, build_promo_tiles(featured, all_products))
     |> assign(:product_tabs, build_product_tabs(new_arrivals, on_sale, featured, bestsellers))
     |> assign(:active_product_tab, "new_arrivals")
     |> assign(:testimonials, Shop.list_testimonials_for_display())
     |> assign(:testimonial_index, 0)}
  end

  # ── Events ────────────────────────────────────────────────────────────────

  @impl true
  def handle_event("select_hero_slide", %{"index" => raw_index}, socket) do
    {:noreply, assign(socket, :hero_index, clamp_index(raw_index, socket.assigns.hero_slides))}
  end

  @impl true
  def handle_event("select_product_tab", %{"tab" => tab}, socket) do
    known = Enum.map(socket.assigns.product_tabs, & &1.key)

    {:noreply,
     assign(socket, :active_product_tab, if(tab in known, do: tab, else: "new_arrivals"))}
  end

  @impl true
  def handle_event("next_testimonial", _params, socket) do
    {:noreply, assign(socket, :testimonial_index, socket.assigns.testimonial_index + 1)}
  end

  @impl true
  def handle_event("prev_testimonial", _params, socket) do
    {:noreply, assign(socket, :testimonial_index, socket.assigns.testimonial_index - 1)}
  end

  @impl true
  def handle_event("subscribe_newsletter", _params, socket) do
    {:noreply,
     put_flash(socket, :info, "Thanks for subscribing! Watch your inbox for new deals.")}
  end

  # ── Render ────────────────────────────────────────────────────────────────

  @impl true
  def render(assigns) do
    ~H"""
    <div id="home-page" class="bg-surface">
      <.store_chrome current_user={@current_user} collections={@collections} active="Home" />

      <.store_hero slides={@hero_slides} current_index={@hero_index} />
      <.feature_strip />

      <.product_section
        id="deals"
        title="Deals of the Week"
        products={@deals}
        view_all_href="/collections"
      />

      <.promo_tiles tiles={@promo_tiles} />

      <.tabbed_products
        tabs={@product_tabs}
        active_tab={@active_product_tab}
        view_all_href="/collections"
      />

      <.brand_row />

      <.testimonial_carousel testimonials={@testimonials} current_index={@testimonial_index} />

      <.newsletter />
      <.store_footer collections={@collections} />
      <.floating_cart_cta />
    </div>
    """
  end

  # ── Assign builders ───────────────────────────────────────────────────────

  # The hero rotates through up to three headline products.
  defp build_hero_slides(featured, fallback) do
    featured
    |> pick(fallback, 3)
    |> Enum.map(fn product ->
      %{
        title: product.name,
        description: truncate(product.description, 180),
        image: hero_image(product),
        href: "/products/#{product.slug}"
      }
    end)
  end

  defp build_promo_tiles(featured, fallback) do
    featured
    |> pick(fallback, 2)
    |> Enum.with_index()
    |> Enum.map(fn {product, index} ->
      %{product: product, tint: Enum.at(@promo_tints, rem(index, length(@promo_tints)))}
    end)
  end

  defp build_product_tabs(new_arrivals, on_sale, featured, bestsellers) do
    [
      %{key: "new_arrivals", label: "New Arrivals", products: Enum.take(new_arrivals, 4)},
      %{key: "offers", label: "Ongoing Offers", products: Enum.take(on_sale, 4)},
      %{key: "featured", label: "Featured Products", products: Enum.take(featured, 4)},
      %{key: "bestsellers", label: "Best Sellers", products: Enum.take(bestsellers, 4)}
    ]
  end

  # Prefers `primary`, topping up from `fallback` when there aren't enough.
  defp pick(primary, fallback, count) do
    chosen = Enum.take(primary, count)

    if length(chosen) >= count do
      chosen
    else
      taken_ids = MapSet.new(chosen, & &1.id)

      chosen ++
        (fallback
         |> Enum.reject(&MapSet.member?(taken_ids, &1.id))
         |> Enum.take(count - length(chosen)))
    end
  end

  defp clamp_index(raw_index, list) do
    max_index = max(length(list) - 1, 0)

    case Integer.parse(to_string(raw_index)) do
      {index, _} -> index |> max(0) |> min(max_index)
      :error -> 0
    end
  end

  defp hero_image(%{slug: slug}) when slug in ["vr-headset", "virtual-reality-vr-headset"],
    do: "/images/products/electronics/vr-headset-hero-v2.png"

  defp hero_image(product), do: product.main_image

  defp truncate(nil, _limit), do: ""

  defp truncate(text, limit) do
    if String.length(text) > limit do
      String.slice(text, 0, limit) |> String.trim_trailing() |> Kernel.<>("…")
    else
      text
    end
  end
end
