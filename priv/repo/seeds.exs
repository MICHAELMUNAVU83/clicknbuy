alias Clicknbuy.Repo
alias Clicknbuy.Collections.Collection
alias Clicknbuy.Products.Product
alias Clicknbuy.ProductVariants.ProductVariant
alias Clicknbuy.Testimonials.Testimonial
alias Clicknbuy.InfoPages.InfoPage

# Stable Unsplash CDN URLs keep the seed data realistic without checking large
# binary assets into the repository. The photo IDs are fixed; only Unsplash's
# delivery parameters are varied by the browser/CDN.
unsplash_photo = fn photo_id ->
  "https://images.unsplash.com/photo-#{photo_id}?auto=format&fit=crop&w=1200&q=85"
end

# Clear existing seed data so seeds can be re-run safely
Repo.delete_all(Clicknbuy.Testimonials.Testimonial)
Repo.delete_all(Clicknbuy.BundleItems.BundleItem)
Repo.delete_all(Clicknbuy.Bundles.Bundle)
Repo.delete_all(Clicknbuy.ProductVariants.ProductVariant)
Repo.delete_all(Clicknbuy.ProductImages.ProductImage)
Repo.delete_all(Clicknbuy.Products.Product)
Repo.delete_all(Clicknbuy.Collections.Collection)
IO.puts("🗑️   Cleared existing data.")

# ─── Collections ────────────────────────────────────────────────────────────

collections =
  [
    %{
      title: "Audio & Sound",
      slug: "audio-sound",
      image: unsplash_photo.("1505740420928-5e560c06d30e"),
      position: 1,
      is_active: true
    },
    %{
      title: "Wearables",
      slug: "wearables",
      image: unsplash_photo.("1523275335684-37898b6baf30"),
      position: 2,
      is_active: true
    },
    %{
      title: "Computing",
      slug: "computing",
      image: unsplash_photo.("1527443224154-c4a3942d3acf"),
      position: 3,
      is_active: true
    },
    %{
      title: "Phones & Accessories",
      slug: "phones-accessories",
      image: unsplash_photo.("1511707171634-5f897ff02aa9"),
      position: 4,
      is_active: true
    },
    %{
      title: "Gaming & VR",
      slug: "gaming-vr",
      image: unsplash_photo.("1622979135225-d2ba269cf1ac"),
      position: 5,
      is_active: true
    }
  ]

inserted_collections =
  Enum.map(collections, fn attrs ->
    {:ok, collection} =
      %Collection{}
      |> Collection.changeset(attrs)
      |> Repo.insert()

    collection
  end)

get_collection = fn slug ->
  Enum.find(inserted_collections, &(&1.slug == slug))
end

# ─── Products ────────────────────────────────────────────────────────────────

products = [
  # ProductVariant requires a size, so `sizes` carries the variant axis where
  # one exists (case size, capacity, layout) and ["Standard"] where it doesn't.
  # ── Audio & Sound ──
  %{
    name: "Wireless Airbuds Pro",
    slug: "wireless-airbuds-pro",
    description:
      "True-wireless earbuds with active noise cancellation, 6 hours of playback per charge and 24 hours total from the pocket-sized case. Bluetooth 5.3 pairs instantly and stays locked in on the move.",
    base_price: 3_500,
    compare_at_price: 4_800,
    sku: "CNB-AUD-1001",
    image: unsplash_photo.("1606220945770-b5b6c2c55bf1"),
    badge_label: "Bestseller",
    badge_color: "red",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 1,
    status: "active",
    size_advice:
      "One size, with small, medium and large silicone tips in the box. Use the largest tip that stays comfortable — a proper seal is what makes noise cancellation work.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty on manufacturing defects. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "audio-sound",
    sizes: ["Standard"],
    colors: [{"Midnight Black", "#1A1A1A"}, {"Pearl White", "#F5F5F5"}]
  },
  %{
    name: "Digital Bluetooth Speaker",
    slug: "digital-bluetooth-speaker",
    description:
      "Pill-shaped portable speaker with dual passive radiators for bass you can feel. IPX6 splash resistance, 12-hour battery and a built-in mic for hands-free calls.",
    base_price: 6_200,
    compare_at_price: 7_500,
    sku: "CNB-AUD-1002",
    image: unsplash_photo.("1608043152269-423dbba4e7e1"),
    badge_label: "On Sale",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 2,
    status: "active",
    size_advice:
      "Compact at 18cm long — fits a backpack side pocket. Pair two units over Bluetooth for true stereo.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "audio-sound",
    sizes: ["Standard"],
    colors: [{"Black", "#1A1A1A"}, {"Navy", "#1E3A5F"}]
  },
  %{
    name: "Studio Over-Ear Headphones",
    slug: "studio-over-ear-headphones",
    description:
      "Closed-back over-ear headphones with 40mm drivers and memory-foam cushions that stay comfortable through long sessions. Wired or wireless, with 30 hours of playback.",
    base_price: 8_900,
    sku: "CNB-AUD-1003",
    image: unsplash_photo.("1505740420928-5e560c06d30e"),
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: true,
    is_new_arrival: true,
    position: 3,
    status: "active",
    size_advice:
      "Adjustable headband fits most adults. Ear cups swivel flat for storage in the included case.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "audio-sound",
    sizes: ["Standard"],
    colors: [{"Black", "#1A1A1A"}, {"Sand", "#D4B896"}]
  },
  %{
    name: "Portable Party Speaker 40W",
    slug: "portable-party-speaker",
    description:
      "40W of output with a carry handle, RGB light ring and a wired mic input for karaoke. Plays 10 hours at volume and doubles as a power bank for your phone.",
    base_price: 12_500,
    compare_at_price: 15_000,
    sku: "CNB-AUD-1004",
    image: unsplash_photo.("1589003077984-894e133dabab"),
    badge_label: "On Sale",
    badge_color: "blue",
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: true,
    position: 4,
    status: "active",
    size_advice:
      "32cm tall and 2.4kg — portable but substantial. Mic and 3.5mm cable are included.",
    shipping_returns:
      "Nairobi delivery KES 300 (1–2 days). Countrywide KES 600–800 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "audio-sound",
    sizes: ["Standard"],
    colors: [{"Black", "#1A1A1A"}]
  },

  # ── Wearables ──
  %{
    name: "Smart Watch Series 5",
    slug: "smart-watch-series-5",
    description:
      "1.85-inch AMOLED smart watch tracking heart rate, blood oxygen and sleep, with over 100 workout modes. Bluetooth calling built in and 7 days between charges.",
    base_price: 7_800,
    compare_at_price: 9_500,
    sku: "CNB-WEA-2001",
    image: unsplash_photo.("1523275335684-37898b6baf30"),
    badge_label: "Bestseller",
    badge_color: "red",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: true,
    position: 5,
    status: "active",
    size_advice:
      "Two case sizes: 41mm suits wrists under 17cm, 45mm above. Straps are quick-release and swap in seconds.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "wearables",
    sizes: ["41mm", "45mm"],
    colors: [{"Black", "#1A1A1A"}, {"Silver", "#C0C0C0"}, {"Rose Gold", "#E8B4A0"}]
  },
  %{
    name: "Fitness Tracker Band",
    slug: "fitness-tracker-band",
    description:
      "Lightweight band with a colour touch display, step and calorie tracking, sleep scoring and smartphone notifications. Water resistant to 50m and runs 14 days per charge.",
    base_price: 3_200,
    sku: "CNB-WEA-2002",
    image: unsplash_photo.("1575311373937-040b8e1fd5b6"),
    badge_label: "New",
    badge_color: "green",
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: true,
    position: 6,
    status: "active",
    size_advice:
      "Silicone strap adjusts from 14cm to 21cm, so it fits most wrists including children's.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "wearables",
    sizes: ["Standard"],
    colors: [{"Purple", "#8B7BD8"}, {"Black", "#1A1A1A"}, {"Teal", "#3AA8A0"}]
  },
  %{
    name: "Chronograph Luxury Watch",
    slug: "chronograph-luxury-watch",
    description:
      "Stainless steel chronograph with a sunray dial, luminous hands and a sapphire-coated crystal. Quartz movement, 44mm case and 50m water resistance.",
    base_price: 14_500,
    sku: "CNB-WEA-2003",
    image: unsplash_photo.("1524805444758-089113d48a6d"),
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: true,
    is_new_arrival: false,
    position: 7,
    status: "active",
    size_advice:
      "44mm case with a 22mm strap — a deliberately bold profile. Links can be removed by any jeweller for a closer fit.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 24-month movement warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "wearables",
    sizes: ["Standard"],
    colors: [{"Gold/Black", "#C9A227"}, {"Silver/Blue", "#8A9BB0"}]
  },

  # ── Computing ──
  %{
    name: "RGB Mechanical Gaming Keyboard",
    slug: "rgb-mechanical-keyboard",
    description:
      "Full-size mechanical keyboard with hot-swappable blue switches, per-key RGB lighting and a detachable USB-C cable. Double-shot keycaps that won't wear smooth.",
    base_price: 6_800,
    compare_at_price: 8_200,
    sku: "CNB-CMP-3001",
    image: unsplash_photo.("1587829741301-dc798b83add3"),
    badge_label: "On Sale",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 8,
    status: "active",
    size_advice:
      "Choose full-size for the number pad, or TKL to free up desk space for mouse movement.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "computing",
    sizes: ["Full-size", "TKL"],
    colors: [{"Black", "#1A1A1A"}, {"White", "#F5F5F5"}]
  },
  %{
    name: "Wireless Optical Mouse",
    slug: "wireless-optical-mouse",
    description:
      "Quiet-click 2.4GHz wireless mouse with a 1600 DPI optical sensor and contoured grip. Runs about 9 months on one AA battery and the nano receiver stores inside.",
    base_price: 1_800,
    sku: "CNB-CMP-3002",
    image: unsplash_photo.("1527814050087-3793815479db"),
    badge_label: nil,
    badge_color: nil,
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: false,
    position: 9,
    status: "active",
    size_advice: "Mid-size ambidextrous shell that suits palm and claw grips alike.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "computing",
    sizes: ["Standard"],
    colors: [{"Red", "#CC2936"}, {"Black", "#1A1A1A"}, {"Grey", "#8A8A8A"}]
  },
  %{
    name: "27-inch 4K UHD Monitor",
    slug: "4k-uhd-monitor-27",
    description:
      "27-inch 3840×2160 IPS panel covering 99% sRGB, with HDR10, a 75Hz refresh rate and a tilt stand. Two HDMI inputs plus DisplayPort and built-in speakers.",
    base_price: 42_000,
    compare_at_price: 48_000,
    sku: "CNB-CMP-3003",
    image: unsplash_photo.("1527443224154-c4a3942d3acf"),
    badge_label: "On Sale",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: true,
    position: 10,
    status: "active",
    size_advice:
      "27-inch is the sweet spot for 4K at normal desk distance. Go 32-inch if you sit further back or want larger text without scaling.",
    shipping_returns:
      "Nairobi delivery KES 500 (1–2 days, boxed). Countrywide KES 1,000–1,500 (2–4 days). 24-month warranty with dead-pixel cover. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "computing",
    sizes: ["27-inch", "32-inch"],
    colors: [{"Black", "#1A1A1A"}]
  },
  %{
    name: "USB-C Docking Station",
    slug: "usb-c-docking-station",
    description:
      "Nine-in-one hub turning a single USB-C port into dual HDMI, three USB-A ports, gigabit ethernet, SD and microSD readers, plus 100W pass-through charging.",
    base_price: 9_500,
    sku: "CNB-CMP-3004",
    image: unsplash_photo.("1496181133206-80ce9b88a853"),
    badge_label: "New",
    badge_color: "green",
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: true,
    position: 11,
    status: "active",
    size_advice:
      "Requires a USB-C port with DisplayPort Alt Mode — standard on modern laptops. Dual 4K output needs a Thunderbolt host.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "computing",
    sizes: ["Standard"],
    colors: [{"Space Grey", "#6E6E73"}]
  },
  %{
    name: "Laptop Cooling Stand",
    slug: "laptop-cooling-stand",
    description:
      "Aluminium riser with two silent fans and six height settings, lifting your screen to eye level while keeping airflow under the chassis. Fits 12 to 17-inch laptops.",
    base_price: 2_900,
    sku: "CNB-CMP-3005",
    image: unsplash_photo.("1496181133206-80ce9b88a853"),
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 12,
    status: "active",
    size_advice:
      "Fits 12-inch to 17-inch laptops. Powered over USB from the laptop itself — no wall adapter.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "computing",
    sizes: ["Standard"],
    colors: [{"Silver", "#C0C0C0"}, {"Black", "#1A1A1A"}]
  },

  # ── Phones & Accessories ──
  %{
    name: "Power Bank 20,000mAh",
    slug: "power-bank-20000mah",
    description:
      "20,000mAh power bank with 22.5W fast charging over USB-C PD, two USB-A outputs and a digital battery readout. Roughly four full phone charges per fill.",
    base_price: 4_200,
    compare_at_price: 5_200,
    sku: "CNB-PHN-4001",
    image: unsplash_photo.("1609592806596-b43bada2f2eb"),
    badge_label: "Bestseller",
    badge_color: "red",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 13,
    status: "active",
    size_advice:
      "Airline-safe at 74Wh, so it's fine in carry-on. Recharges fully in about 5 hours with a 20W adapter.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "phones-accessories",
    sizes: ["Standard"],
    colors: [{"Black", "#1A1A1A"}, {"White", "#F5F5F5"}]
  },
  %{
    name: "GaN Fast Charger 65W",
    slug: "gan-fast-charger-65w",
    description:
      "Compact 65W GaN charger with two USB-C ports and one USB-A, enough to run a laptop and phone together. Half the size of the brick that came in the box.",
    base_price: 3_100,
    sku: "CNB-PHN-4002",
    image: unsplash_photo.("1583863788434-e58a36330cf0"),
    badge_label: "New",
    badge_color: "green",
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: true,
    position: 14,
    status: "active",
    size_advice:
      "UK three-pin plug as standard. Using all three ports at once splits the 65W between them.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 18-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "phones-accessories",
    sizes: ["Standard"],
    colors: [{"White", "#F5F5F5"}, {"Black", "#1A1A1A"}]
  },
  %{
    name: "Tempered Glass Screen Protector",
    slug: "tempered-glass-protector",
    description:
      "Two-pack of 9H tempered glass protectors with an oleophobic coating that resists fingerprints. Alignment frame and cleaning kit included for a bubble-free fit.",
    base_price: 900,
    sku: "CNB-PHN-4003",
    image: unsplash_photo.("1511707171634-5f897ff02aa9"),
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 15,
    status: "active",
    size_advice:
      "Tell us your exact phone model on WhatsApp when ordering and we'll match the cut before dispatch.",
    shipping_returns:
      "Nairobi delivery KES 200 (1–2 days). Countrywide KES 400 (2–4 days). Replacement if it cracks during fitting. WhatsApp 0796 770 862.",
    collection_slug: "phones-accessories",
    sizes: ["Standard"],
    colors: [{"Clear", "#E8ECF8"}]
  },

  # ── Gaming & VR ──
  %{
    name: "Virtual Reality (VR) Headset",
    slug: "vr-headset",
    description:
      "Standalone VR headset with dual 2K lenses, 6DoF inside-out tracking and a 110-degree field of view. Adjustable head strap and two motion controllers in the box.",
    base_price: 28_000,
    compare_at_price: 34_000,
    sku: "CNB-GAM-5001",
    image: unsplash_photo.("1622979135225-d2ba269cf1ac"),
    badge_label: "On Sale",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: true,
    position: 16,
    status: "active",
    size_advice:
      "Adjustable strap fits most head sizes and the lens spacing moves to match your eyes. Glasses up to 145mm wide fit inside the spacer.",
    shipping_returns:
      "Nairobi delivery KES 300–500 (1–2 days). Countrywide KES 800–1,200 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "gaming-vr",
    sizes: ["128GB", "256GB"],
    colors: [{"White", "#F5F5F5"}, {"Black", "#1A1A1A"}]
  },
  %{
    name: "Wireless Game Controller",
    slug: "wireless-game-controller",
    description:
      "Bluetooth controller with hall-effect sticks that won't drift, dual rumble motors and 20 hours of play per charge. Works with PC, Android, iOS and Switch.",
    base_price: 5_400,
    sku: "CNB-GAM-5002",
    image: unsplash_photo.("1592840496694-26d035b52b48"),
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: true,
    position: 17,
    status: "active",
    size_advice:
      "Standard full-size layout. Includes a USB-C cable so you can play wired with zero latency.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). 12-month warranty. Sealed returns within 7 days. WhatsApp 0796 770 862.",
    collection_slug: "gaming-vr",
    sizes: ["Standard"],
    colors: [{"Black", "#1A1A1A"}, {"White", "#F5F5F5"}]
  }
]

default_sizes = ["Standard"]

inserted_products =
  Enum.map(products, fn attrs ->
    {collection_slug, attrs} = Map.pop(attrs, :collection_slug)
    {colors, attrs} = Map.pop(attrs, :colors)
    {sizes, attrs} = Map.pop(attrs, :sizes, default_sizes)
    collection = get_collection.(collection_slug)
    attrs = Map.put(attrs, :collection_id, collection.id)

    position = attrs[:position] || 1

    # Fill in a SKU when the product didn't declare one, and put roughly every
    # third un-priced product on sale at ~25% above the live price. Explicit
    # :sku / :compare_at_price values always win.
    attrs =
      attrs
      |> Map.put_new_lazy(:sku, fn ->
        "CNB" <> String.pad_leading(to_string(position * 7 + 1000), 5, "0")
      end)
      |> then(fn a ->
        if Map.has_key?(a, :compare_at_price) or rem(position, 3) != 1 do
          a
        else
          Map.put(a, :compare_at_price, round(a.base_price * 1.25 / 100) * 100)
        end
      end)

    {:ok, product} =
      %Product{}
      |> Product.changeset(attrs)
      |> Repo.insert()

    # Seed the hero photo into the product gallery as well, so product detail
    # pages and catalog cards use the same Unsplash image.
    gallery = [attrs.image]

    gallery
    |> Enum.with_index(1)
    |> Enum.each(fn {image, idx} ->
      {:ok, _} =
        %Clicknbuy.ProductImages.ProductImage{}
        |> Clicknbuy.ProductImages.ProductImage.changeset(%{
          product_id: product.id,
          image: image,
          # position is a :string column, so Ecto won't cast an integer here
          position: to_string(idx)
        })
        |> Repo.insert()
    end)

    # Insert one variant per colour × size combination
    Enum.each(colors, fn {color_name, color_hex} ->
      Enum.each(sizes, fn size ->
        {:ok, _} =
          %ProductVariant{}
          |> ProductVariant.changeset(%{
            product_id: product.id,
            color_name: color_name,
            color_hex: color_hex,
            size: size,
            stock_quantity: "10"
          })
          |> Repo.insert()
      end)
    end)

    product
  end)

get_product = fn slug ->
  Enum.find(inserted_products, &(&1.slug == slug))
end

variant_count = Repo.aggregate(ProductVariant, :count)
image_count = Repo.aggregate(Clicknbuy.ProductImages.ProductImage, :count)

IO.puts(
  "✅  Seeded #{length(inserted_collections)} collections, #{length(inserted_products)} products, " <>
    "#{variant_count} variants, #{image_count} images."
)

# ─── Bundle ───────────────────────────────────────────────────────────────────

{:ok, bundle} =
  %Clicknbuy.Bundles.Bundle{}
  |> Clicknbuy.Bundles.Bundle.changeset(%{
    title: "The Click N Buy Work-From-Home Bundle",
    description:
      "Everything you need for a productive desk, bought together and priced better. Pairs our 27-inch 4K monitor with the RGB mechanical keyboard, the wireless optical mouse and the USB-C docking station — one cable to your laptop and you're running.",
    image: unsplash_photo.("1527443224154-c4a3942d3acf"),
    is_active: true
  })
  |> Repo.insert()

bundle_item_slugs = [
  "4k-uhd-monitor-27",
  "rgb-mechanical-keyboard",
  "wireless-optical-mouse",
  "usb-c-docking-station"
]

Enum.each(bundle_item_slugs, fn slug ->
  product = get_product.(slug)

  {:ok, _} =
    %Clicknbuy.BundleItems.BundleItem{}
    |> Clicknbuy.BundleItems.BundleItem.changeset(%{
      bundle_id: bundle.id,
      product_id: product.id
    })
    |> Repo.insert()
end)

IO.puts("✅  Seeded 1 bundle with #{length(bundle_item_slugs)} items.")

# ─── Testimonials ─────────────────────────────────────────────────────────────

testimonials = [
  %{
    name: "Brian K.",
    position: 1,
    image: "/images/people/avatars/bk.svg",
    body:
      "The Airbuds Pro punch well above their price. Noise cancellation genuinely works on a matatu commute and the case lasts me the whole week. Ordered at 11am, had them by evening.",
    rating: 5,
    is_active: true,
    product_slug: "wireless-airbuds-pro"
  },
  %{
    name: "Sharon M.",
    position: 2,
    image: "/images/people/avatars/sm.svg",
    body:
      "I use the Smart Watch Series 5 for morning runs and the heart-rate tracking matches my gym equipment closely. Battery really does go a week. The 41mm size was the right call for my wrist.",
    rating: 5,
    is_active: true,
    product_slug: "smart-watch-series-5"
  },
  %{
    name: "James O.",
    position: 3,
    image: "/images/people/avatars/jo.svg",
    body:
      "Bought the 27-inch 4K monitor for design work and the colour accuracy is excellent straight out of the box. It arrived properly boxed and padded, which I did not take for granted.",
    rating: 5,
    is_active: true,
    product_slug: "4k-uhd-monitor-27"
  },
  %{
    name: "Peter W.",
    position: 4,
    image: "/images/people/avatars/pw.svg",
    body:
      "The mechanical keyboard feels superb and the hot-swap switches meant I could change to quieter ones for the office without buying a new board. Great value for the price.",
    rating: 5,
    is_active: true,
    product_slug: "rgb-mechanical-keyboard"
  }
]

Enum.each(testimonials, fn attrs ->
  {product_slug, attrs} = Map.pop(attrs, :product_slug)
  product = get_product.(product_slug)

  {:ok, _} =
    %Testimonial{}
    |> Testimonial.changeset(Map.put(attrs, :product_id, product.id))
    |> Repo.insert()
end)

IO.puts("✅  Seeded #{length(testimonials)} testimonials.")

# ── Info Pages ────────────────────────────────────────────────────────────────

# Info pages are NOT cleared on re-seed so admin edits are preserved.
# Only insert when the slug doesn't already exist.
info_pages = [
  %{
    slug: "how-to-order",
    title: "How to Order",
    icon: "🛍️",
    position: 1,
    meta_description:
      "Step-by-step guide on how to place an order at Click N Buy — shop online or via WhatsApp.",
    content: """
    ## How to Place Your Order

    Ordering from Click N Buy is simple and straightforward. Here's how:

    ### Option 1 — Order via WhatsApp (Recommended)

    - Screenshot or share the product you love from our Instagram or website.
    - Send us a message on **WhatsApp: 0796 770 862**.
    - Let us know the **model or capacity**, preferred **colour**, and **delivery location**.
    - We'll confirm availability and send you the total including delivery.
    - Make payment via **M-Pesa Till No. 5894819**.
    - Send us the M-Pesa confirmation message.
    - Your order will be dispatched within 24 hours!

    ### Option 2 — Order via the Website

    - Browse our collections and add items to your cart.
    - Proceed to **Checkout** and fill in your delivery details.
    - Complete payment via M-Pesa.
    - You'll receive an order confirmation via email or WhatsApp.

    ## Payment Methods

    - **M-Pesa Till No. 5894819** (Click N Buy)
    - Bank transfer (available on request)

    ## Need Help?

    If you have any trouble placing an order, don't hesitate to reach out on WhatsApp and we'll assist you immediately.
    """
  },
  %{
    slug: "warranty-support",
    title: "Warranty & Support",
    icon: "🛡️",
    position: 2,
    meta_description:
      "Click N Buy warranty and support — cover periods, what's included and how to make a claim.",
    content: """
    ## Warranty & Support

    Every item we sell is covered against manufacturing defects. Here's what that means in practice.

    ### Cover Periods

    - **Audio, wearables and accessories** — 12 months
    - **Monitors and computing hardware** — 24 months, including dead-pixel cover
    - **Chargers and power banks** — 18 months
    - **Cables, screen protectors and consumables** — 3 months

    ### What's Covered

    - Faults present from new, or that appear in normal use
    - Battery capacity dropping below 70% within the warranty period
    - Dead or stuck pixels on monitors, per the manufacturer threshold
    - Ports, buttons and switches failing under normal use

    ### What's Not Covered

    - Physical damage, drops, crushing or bent connectors
    - Liquid damage beyond the item's stated IP rating
    - Damage from unstable mains power — we strongly recommend a surge protector
    - Software issues, or devices opened by an unauthorised repairer

    ### How to Make a Claim

    - Message us on **WhatsApp: 0796 770 862** with your order reference.
    - Send a short video or photos showing the fault.
    - We respond within 24 hours with next steps.
    - If the fault is confirmed, we repair, replace or refund — your choice where stock allows.

    ### Before You Claim

    A surprising number of faults are fixable in minutes. Try a different cable and wall
    adapter, a different port, and a full power cycle. If the device pairs over Bluetooth,
    remove it from your phone's saved devices and pair again. Still faulty? Message us.

    ## Need a Hand Choosing?

    Not sure which capacity, size or model fits your setup? Message us on
    **WhatsApp: 0796 770 862** and we'll talk it through before you buy.
    """
  },
  %{
    slug: "shipping-delivery",
    title: "Shipping & Delivery",
    icon: "🚚",
    position: 3,
    meta_description:
      "Click N Buy shipping and delivery information — Nairobi same-day delivery and countrywide shipping across Kenya.",
    content: """
    ## Shipping & Delivery

    We deliver across Kenya! Here's everything you need to know about getting your Click N Buy order to your door.

    ### Nairobi Deliveries

    - **Standard Delivery** — 1–2 business days | **KES 200–300**
    - **Same-Day Delivery** — Available for orders placed before 12 PM | **KES 300–500** (select locations)
    - **Pick-Up** — Contact us on WhatsApp to arrange a convenient pick-up point.

    ### Countrywide Deliveries

    - **Courier (G4S / Wells Fargo)** — 2–4 business days | **KES 400–600**
    - **Bus / Matatu Services** — 1–2 business days | Cost varies by distance
    - Delivery fees for upcountry orders are confirmed at checkout or via WhatsApp.

    ### How Delivery Works

    - Once your order is confirmed and payment received, we process and pack within **24 hours**.
    - You'll receive a **WhatsApp notification** when your parcel is dispatched, including tracking details where applicable.
    - For bus deliveries, the bus ticket/tracking number will be shared with you.

    ### Important Notes

    - Delivery timelines exclude weekends and public holidays.
    - Click N Buy is not responsible for delays caused by third-party courier services once the parcel is dispatched.
    - Please ensure your **delivery address and phone number** are accurate when ordering.

    ## Questions?

    Reach us on **WhatsApp: 0796 770 862** for any delivery enquiries.
    """
  },
  %{
    slug: "returns-exchanges",
    title: "Returns & Exchanges",
    icon: "🔄",
    position: 4,
    meta_description:
      "Click N Buy returns and exchanges policy — sealed returns, faulty-item cover and how to start a claim.",
    content: """
    ## Returns & Exchanges

    We want you to be happy with your purchase. If something isn't right, here's what you can do.

    ### Our Policy

    - **Change of mind** — 7 days from delivery, provided the item is **unopened and still sealed**.
    - **Faulty on arrival** — 7 days from delivery, opened is fine. We cover return delivery.
    - Once a sealed item is opened it can only be returned if it is faulty, since we cannot resell it as new.
    - Keep the box, manuals and all included cables — returns need the complete package.

    ### Valid Reasons for Exchange

    - Wrong model, capacity or colour sent (our error)
    - Item dead on arrival or faulty within the warranty period
    - Item damaged in transit — tell us within 24 hours of delivery

    ### How to Request an Exchange

    - Contact us on **WhatsApp: 0796 770 862** within 48 hours of delivery.
    - Share your order details and clear photos of the item(s).
    - Our team will review and respond within 24 hours.
    - If approved, we'll arrange collection and dispatch the replacement.

    ### Exchanges — Different Model or Capacity

    - Swapping for a different model, capacity or colour is subject to stock availability.
    - Where the swap is your preference rather than our error, return delivery is on you.
    - Any price difference is charged or refunded accordingly.

    ### Refunds

    - We do not offer cash refunds except in cases where the item is out of stock and no suitable replacement is available.
    - Refunds, where applicable, are processed within **5–7 business days** via M-Pesa.

    ## Contact Us

    If you have any concerns about your order, please reach out promptly on **WhatsApp: 0796 770 862**. We're here to help!
    """
  }
]

inserted_info_pages =
  Enum.reduce(info_pages, 0, fn attrs, count ->
    case Repo.get_by(InfoPage, slug: attrs.slug) do
      nil ->
        {:ok, _} =
          %InfoPage{}
          |> InfoPage.changeset(attrs)
          |> Repo.insert()

        count + 1

      _existing ->
        count
    end
  end)

IO.puts(
  "✅  Seeded #{inserted_info_pages} info pages (#{length(info_pages) - inserted_info_pages} already existed)."
)

alias Clicknbuy.Repo
alias Clicknbuy.Accounts
alias Clicknbuy.Accounts.User

admin_users = [
  %{
    name: "Michael Munavu",
    email: "michaelmunavu83@gmail.com",
    password: "123456",
    role: "super_admin"
  }
]

inserted =
  Enum.reduce(admin_users, 0, fn attrs, count ->
    case Repo.get_by(User, email: attrs.email) do
      nil ->
        case Accounts.invite_user(attrs) do
          {:ok, _user} ->
            IO.puts("  ✅  Created admin: #{attrs.email}")
            count + 1

          {:error, changeset} ->
            IO.puts("  ❌  Failed to create #{attrs.email}: #{inspect(changeset.errors)}")
            count
        end

      existing ->
        {:ok, _} = Accounts.admin_update_user(existing, Map.take(attrs, [:name, :role]))
        IO.puts("  ℹ️   Already exists (role updated): #{attrs.email}")
        count
    end
  end)

IO.puts("\n✅  Admin seed complete — #{inserted} new user(s) created.")
IO.puts("\n🔐  Default credentials:")

Enum.each(admin_users, fn u ->
  IO.puts("     Email:    #{u.email}")
  IO.puts("     Password: #{u.password}")
  IO.puts("     Role:     #{u.role}")
end)

IO.puts("\n⚠️   Change the password after your first login!\n")

# mix run priv/repo/seeds_admin.exs
