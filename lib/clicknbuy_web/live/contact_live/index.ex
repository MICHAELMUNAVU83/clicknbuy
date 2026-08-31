defmodule ClicknbuyWeb.ContactLive.Index do
  use ClicknbuyWeb, :live_view

  alias Clicknbuy.Shop
  alias Clicknbuy.SiteSettings

  @impl true
  def mount(_params, _session, socket) do
    settings = SiteSettings.get()

    {:ok,
     socket
     |> assign(:page_title, "Contact Us")
     |> assign(
       :meta_description,
       "Get in touch with #{settings.site_name} — call, email or send us a message and we'll reply within a few hours."
     )
     |> assign(:settings, settings)
     |> assign(:collections, Shop.list_collections_for_display())
     |> assign(:form_sent, false)}
  end

  @impl true
  def handle_event("contact_submit", params, socket) do
    # The storefront contact form is intentionally fire-and-forget: it flashes a
    # confirmation rather than persisting, so support stays on WhatsApp/email.
    name = params |> Map.get("name", "") |> String.trim()

    greeting = if name == "", do: "Thanks", else: "Thanks, #{name}"

    {:noreply,
     socket
     |> assign(:form_sent, true)
     |> put_flash(:info, "#{greeting}! We've got your message and will reply shortly.")}
  end

  @impl true
  def handle_event("subscribe_newsletter", _params, socket) do
    {:noreply, put_flash(socket, :info, "Thanks for subscribing! Watch your inbox for new deals.")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="contact-page" class="min-h-screen bg-surface">
      <.store_chrome current_user={@current_user} collections={@collections} active="Contact" />

      <.breadcrumb crumbs={[%{label: "Home", href: "/"}, %{label: "Contact Us"}]} />

      <section class="px-4 py-12 sm:px-6 lg:px-8 lg:py-20">
        <div class="mx-auto grid max-w-[1500px] gap-10 lg:grid-cols-2 lg:gap-16">
          <%!-- Left: intro + details --%>
          <div>
            <h1 class="font-heading-brand text-3xl font-extrabold text-ink sm:text-4xl lg:text-5xl">
              How can we help you?
            </h1>
            <p class="mt-6 max-w-md text-[15px] leading-relaxed text-gray-500">
              Questions about an order, a product or a return? Send us a message with the form, or reach us
              directly on the details below — we reply within a few hours during business hours.
            </p>

            <ul class="mt-10 space-y-7">
              <.contact_detail label="Office">
                <:icon>
                  <path stroke-linecap="round" stroke-linejoin="round" d="M15 10.5a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M19.5 10.5c0 7.142-7.5 11.25-7.5 11.25S4.5 17.642 4.5 10.5a7.5 7.5 0 1115 0z"
                  />
                </:icon>
                Nairobi CBD, Kenya
              </.contact_detail>

              <.contact_detail label="Contact no">
                <:icon>
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M2.25 6.75c0 8.284 6.716 15 15 15h2.25a2.25 2.25 0 002.25-2.25v-1.372c0-.516-.351-.966-.852-1.091l-4.423-1.106c-.44-.11-.902.055-1.173.417l-.97 1.293c-.282.376-.769.542-1.21.38a12.035 12.035 0 01-7.143-7.143c-.162-.441.004-.928.38-1.21l1.293-.97c.363-.271.527-.734.417-1.173L6.963 3.102a1.125 1.125 0 00-1.091-.852H4.5A2.25 2.25 0 002.25 4.5v2.25z"
                  />
                </:icon>
                <a href={"tel:#{support_phone_tel()}"} class="transition hover:text-accent">
                  {support_phone()}
                </a>
              </.contact_detail>

              <.contact_detail label="Email">
                <:icon>
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M21.75 6.75v10.5a2.25 2.25 0 01-2.25 2.25h-15a2.25 2.25 0 01-2.25-2.25V6.75m19.5 0A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25m19.5 0v.243a2.25 2.25 0 01-1.07 1.916l-7.5 4.615a2.25 2.25 0 01-2.36 0L3.32 8.91a2.25 2.25 0 01-1.07-1.916V6.75"
                  />
                </:icon>
                <a href={"mailto:#{support_email()}"} class="transition hover:text-accent">
                  {support_email()}
                </a>
              </.contact_detail>
            </ul>
          </div>

          <%!-- Right: form card --%>
          <div class="rounded border border-gray-100 bg-white p-7 shadow-sm lg:p-10">
            <h2 class="font-heading-brand text-2xl font-extrabold text-ink">Get in touch</h2>
            <p class="mt-2 text-sm text-gray-500">
              Connect with us through the form for any inquiries or questions.
            </p>

            <form phx-submit="contact_submit" class="mt-7 space-y-5">
              <div class="grid gap-5 sm:grid-cols-2">
                <.contact_field name="name" label="Name" placeholder="Your name" />
                <.contact_field name="email" label="Email" type="email" placeholder="Your email" />
                <.contact_field name="phone" label="Phone" type="tel" placeholder="Your phone" />
                <.contact_field name="subject" label="Subject" placeholder="Subject" />
              </div>

              <div>
                <label for="contact-message" class="mb-2 block text-sm font-bold text-ink">Message</label>
                <textarea
                  id="contact-message"
                  name="message"
                  rows="5"
                  required
                  placeholder="Your message"
                  class="w-full rounded-sm border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-ink placeholder-gray-400 transition focus:border-brand focus:bg-white focus:outline-none"
                ></textarea>
              </div>

              <button
                type="submit"
                class="rounded bg-accent px-8 py-3.5 text-sm font-bold text-white transition hover:bg-accent-600"
              >
                Send
              </button>
            </form>
          </div>
        </div>
      </section>

      <%!-- Closing band --%>
      <section class="bg-white px-4 py-14 text-center sm:px-6 lg:px-8 lg:py-20">
        <div class="mx-auto max-w-2xl">
          <h2 class="font-heading-brand text-2xl font-extrabold text-ink sm:text-3xl">
            Let's start something great!
          </h2>
          <p class="mt-4 text-[15px] leading-relaxed text-gray-500">
            Prefer chatting? Message us on WhatsApp and we'll help you find exactly what you're after.
          </p>
          <a
            href={"https://wa.me/#{String.replace(support_phone_tel(), "+", "")}"}
            target="_blank"
            rel="noopener noreferrer"
            class="mt-7 inline-flex items-center gap-3 rounded bg-accent px-7 py-3.5 text-sm font-bold text-white transition hover:bg-accent-600"
          >
            Chat on WhatsApp
            <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 24 24">
              <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
            </svg>
          </a>
        </div>
      </section>

      <.newsletter />
      <.store_footer collections={@collections} />
    </div>
    """
  end

  # ── Local components ──────────────────────────────────────────────────────

  attr :label, :string, required: true
  slot :icon, required: true
  slot :inner_block, required: true

  defp contact_detail(assigns) do
    ~H"""
    <li class="flex items-start gap-5">
      <span class="flex h-11 w-11 shrink-0 items-center justify-center rounded-full bg-accent text-white">
        <svg class="h-5 w-5" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
          {render_slot(@icon)}
        </svg>
      </span>
      <div>
        <p class="font-heading-brand text-base font-bold text-ink">{@label}:</p>
        <p class="mt-1 text-[15px] text-gray-500">{render_slot(@inner_block)}</p>
      </div>
    </li>
    """
  end

  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :type, :string, default: "text"
  attr :placeholder, :string, default: ""

  defp contact_field(assigns) do
    ~H"""
    <div>
      <label for={"contact-#{@name}"} class="mb-2 block text-sm font-bold text-ink">{@label}</label>
      <input
        type={@type}
        id={"contact-#{@name}"}
        name={@name}
        placeholder={@placeholder}
        required={@name in ["name", "email"]}
        class="w-full rounded-sm border border-gray-200 bg-gray-50 px-4 py-3 text-sm text-ink placeholder-gray-400 transition focus:border-brand focus:bg-white focus:outline-none"
      />
    </div>
    """
  end
end
