defmodule ClicknbuyWeb.AboutLive.Index do
  use ClicknbuyWeb, :live_view

  alias Clicknbuy.Shop
  alias Clicknbuy.SiteSettings

  @values [
    %{
      title: "Quality Assurance",
      body: "Every item is inspected before dispatch, so what lands at your door is what you ordered."
    },
    %{
      title: "Wide Selection",
      body: "From everyday essentials to statement pieces, restocked and expanded every month."
    },
    %{
      title: "Competitive Prices",
      body: "We buy well and pass the saving on, with regular offers on the lines you shop most."
    },
    %{
      title: "Exceptional Service",
      body: "Real people on WhatsApp and email, replying in minutes during business hours."
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    settings = SiteSettings.get()

    {:ok,
     socket
     |> assign(:page_title, "About Us")
     |> assign(
       :meta_description,
       "Learn about #{settings.site_name} — our story, our mission and our commitment to customers across Kenya."
     )
     |> assign(:settings, settings)
     |> assign(:collections, Shop.list_collections_for_display())
     |> assign(:values, @values)
     |> assign(:story_images, Shop.list_hero_images(2))
     |> assign(:testimonials, Shop.list_testimonials_for_display())
     |> assign(:testimonial_index, 0)}
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
    {:noreply, put_flash(socket, :info, "Thanks for subscribing! Watch your inbox for new deals.")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="about-page" class="min-h-screen bg-surface">
      <.store_chrome current_user={@current_user} collections={@collections} active="About Us" />

      <.breadcrumb crumbs={[%{label: "Home", href: "/"}, %{label: "About us"}]} />

      <%!-- Welcome + mission --%>
      <section class="px-4 py-12 sm:px-6 lg:px-8 lg:py-20">
        <div class="mx-auto grid max-w-[1500px] items-center gap-10 lg:grid-cols-2 lg:gap-16">
          <%= if image = List.first(@story_images) do %>
            <img
              src={image.image}
              alt={image.alt || "Inside #{@settings.site_name}"}
              class="h-[320px] w-full rounded object-cover lg:h-[460px]"
            />
          <% end %>

          <div>
            <h1 class="font-heading-brand text-3xl font-extrabold text-ink sm:text-4xl lg:text-5xl">
              Welcome to {@settings.site_name}
            </h1>
            <p class="mt-6 text-[15px] leading-relaxed text-gray-500 sm:text-base">
              At {@settings.site_name} we're passionate about making online shopping in Kenya feel simple and
              dependable. Browse, order and pay in a couple of taps — then get on with your day while we handle
              the rest.
            </p>

            <h2 class="mt-10 font-heading-brand text-2xl font-extrabold text-ink sm:text-3xl">
              Our Mission
            </h2>
            <p class="mt-5 text-[15px] leading-relaxed text-gray-500 sm:text-base">
              To offer a genuinely useful selection of quality products at fair prices, backed by fast delivery
              and hassle-free returns. Your satisfaction is the thing we optimise for — every order, every time.
            </p>
          </div>
        </div>
      </section>

      <%!-- Our story --%>
      <section class="bg-white px-4 py-12 sm:px-6 lg:px-8 lg:py-20">
        <div class="mx-auto grid max-w-[1500px] items-center gap-10 lg:grid-cols-2 lg:gap-16">
          <div class="order-2 lg:order-1">
            <h2 class="font-heading-brand text-3xl font-extrabold text-ink sm:text-4xl">Our Story</h2>
            <p class="mt-6 text-[15px] leading-relaxed text-gray-500 sm:text-base">
              {@settings.site_name} started with a simple idea: shopping online in Kenya should be as easy as
              messaging a friend. What began as a small operation run out of Nairobi has grown into a store
              serving customers countrywide — still answering every message ourselves.
            </p>
            <.link
              navigate="/collections"
              class="mt-8 inline-flex items-center gap-3 rounded bg-accent px-7 py-3.5 text-sm font-bold text-white transition hover:bg-accent-600"
            >
              Start Shopping
              <svg class="h-4 w-4" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12h15m0 0l-6-6m6 6l-6 6" />
              </svg>
            </.link>
          </div>

          <div class="order-1 grid gap-5 sm:grid-cols-2 lg:order-2">
            <%= for image <- Enum.take(@story_images, 2) do %>
              <img
                src={image.image}
                alt={image.alt || ""}
                class="h-[240px] w-full rounded object-cover lg:h-[320px]"
              />
            <% end %>
          </div>
        </div>
      </section>

      <%!-- Values --%>
      <section class="bg-white px-4 pb-12 sm:px-6 lg:px-8 lg:pb-20">
        <div class="mx-auto max-w-[1500px]">
          <div class="grid divide-y divide-gray-100 border-y border-gray-100 sm:grid-cols-2 sm:divide-y-0 lg:grid-cols-4 lg:divide-x">
            <%= for value <- @values do %>
              <div class="px-6 py-10 text-center">
                <h3 class="font-heading-brand text-base font-bold text-ink">{value.title}</h3>
                <p class="mt-3 text-sm leading-relaxed text-gray-500">{value.body}</p>
              </div>
            <% end %>
          </div>
        </div>
      </section>

      <.testimonial_carousel testimonials={@testimonials} current_index={@testimonial_index} />

      <.newsletter />
      <.store_footer collections={@collections} />
      <.floating_cart_cta />
    </div>
    """
  end
end
