alias Clicknbuy.Repo
alias Clicknbuy.Collections.Collection
alias Clicknbuy.Products.Product
alias Clicknbuy.ProductVariants.ProductVariant
alias Clicknbuy.Testimonials.Testimonial
alias Clicknbuy.InfoPages.InfoPage

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
      title: "Co-ord Sets",
      slug: "coord-sets",
      image: "/images/products/red-denim-coord-set.jpg",
      position: 1,
      is_active: true
    },
    %{
      title: "Wide-Leg Pants",
      slug: "wide-leg-pants",
      image: "/images/products/black-wide-leg-pants-floral-top.jpg",
      position: 2,
      is_active: true
    },
    %{
      title: "Skirts",
      slug: "skirts",
      image: "/images/products/denim-maxi-skirt-front.jpg",
      position: 3,
      is_active: true
    },
    %{
      title: "Jumpsuits",
      slug: "jumpsuits",
      image: "/images/products/sage-linen-jumpsuit.jpg",
      position: 4,
      is_active: true
    },
    %{
      title: "Tops & Knits",
      slug: "tops-and-knits",
      image: "/images/products/grey-layered-knit-set-front.jpg",
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
  # ── Co-ord Sets ──────────────────────────────────────────────────────────
  %{
    name: "Red & Denim Co-ord Set",
    slug: "red-denim-coord-set",
    description:
      "A bold statement co-ord set featuring a cropped red sweatshirt layered over a denim shirt, paired with matching red wide-leg trousers finished with raw-hem denim side-stripe detailing. Effortlessly cool with white sneakers.",
    base_price: 4_800,
    image: "/images/products/red-denim-coord-set.jpg",
    badge_label: "Bestseller",
    badge_color: "red",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 1,
    status: "active",
    size_advice:
      "Runs true to size. The trousers have a drawstring waist for a flexible fit. If between sizes, size up for comfort. Model is 5'6\" wearing a size M. Measure your bust and hips before ordering.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "coord-sets",
    colors: [{"Red", "#CC2936"}, {"Denim Blue", "#4A7FB5"}]
  },
  %{
    name: "Orange & Denim Co-ord Set",
    slug: "orange-denim-coord-set",
    description:
      "Vibrant burnt-orange co-ord set with a cropped pullover and wide-leg trousers, both accented with frayed denim contrast panels and cuffs. A denim shirt peeking underneath adds a layered finish.",
    base_price: 4_800,
    image: "/images/products/orange-denim-coord-set.jpg",
    badge_label: "New",
    badge_color: "green",
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: true,
    position: 2,
    status: "active",
    size_advice:
      "Runs true to size. Bold, relaxed silhouette — if you prefer a more fitted look, size down. Drawstring trousers adjust easily. Measure your waist and hips for the best fit.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "coord-sets",
    colors: [{"Orange", "#F97316"}, {"Denim Blue", "#4A7FB5"}]
  },
  %{
    name: "Chocolate Knit Co-ord Set",
    slug: "chocolate-knit-coord-set",
    description:
      "Luxuriously soft chocolate-brown knit co-ord set comprising an oversized drop-shoulder sweater with a cream contrast stripe hem and matching wide-leg knit trousers. The ultimate cosy-chic look.",
    base_price: 5_200,
    image: "/images/products/chocolate-knit-coord-set.jpg",
    badge_label: "New",
    badge_color: "green",
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: true,
    position: 3,
    status: "active",
    size_advice:
      "This oversized knit set runs generously. For a cosy relaxed fit, take your usual size. For a more structured look, size down one. The sweater has a deep drop-shoulder so measure your bust width.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "coord-sets",
    colors: [{"Chocolate", "#7B3F00"}, {"Cream", "#F5F0E8"}]
  },
  %{
    name: "Sage Linen Co-ord Set",
    slug: "sage-linen-coord-set",
    description:
      "Breezy sage-green linen co-ord set with a frilled-shoulder crop top and matching drawstring wide-leg trousers. Lightweight and effortlessly elegant for warm days.",
    base_price: 4_200,
    image: "/images/products/sage-linen-coord-set.jpg",
    badge_label: "Featured",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: false,
    position: 4,
    status: "active",
    size_advice:
      "Runs true to size. Linen has a natural relaxed drape. The frilled shoulder top suits a range of bust sizes and the drawstring trousers give flexibility. Model is 5'6\" in a size M.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "coord-sets",
    colors: [{"Sage Green", "#8FAF7E"}, {"Olive", "#6B7C4A"}]
  },
  %{
    name: "Olive Linen Co-ord Set",
    slug: "olive-linen-coord-set",
    description:
      "Relaxed olive-green linen co-ord featuring a V-neck button-front tunic top with pearl buttons and matching wide-leg trousers. Pairs beautifully with heeled sandals for a polished casual look.",
    base_price: 4_500,
    image: "/images/products/olive-linen-coord-set.jpg",
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 5,
    status: "active",
    size_advice:
      "Runs true to size. The V-neck button-front top has a relaxed fit — measure your bust for the best button closure. Trousers have an elasticated drawstring waist for a comfortable, adjustable fit.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "coord-sets",
    colors: [{"Olive", "#6B7C4A"}, {"Cream", "#F5F0E8"}]
  },

  # ── Wide-Leg Pants ────────────────────────────────────────────────────────
  %{
    name: "Black Wide-Leg Palazzo Pants",
    slug: "black-wide-leg-palazzo-pants",
    description:
      "Sleek high-waisted black palazzo pants with a structured belt and deep pleats for a dramatic silhouette. The statement piece in any wardrobe — style with a crop top or tucked-in blouse.",
    base_price: 2_800,
    image: "/images/products/black-wide-leg-pants-floral-top.jpg",
    badge_label: "Bestseller",
    badge_color: "red",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 6,
    status: "active",
    size_advice:
      "High-waisted fit — measure your natural waist. These run true to size with no stretch. The belt is included and fully adjustable. Model wears a size M. If between sizes, size up for the waist.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "wide-leg-pants",
    colors: [{"Black", "#1A1A1A"}, {"White", "#F5F5F5"}]
  },
  %{
    name: "Navy Wide-Leg Palazzo Pants",
    slug: "navy-wide-leg-palazzo-pants",
    description:
      "Fluid navy high-waisted palazzo pants with a matching belt and front pleats. Versatile enough for day or evening wear — shown here with a tie-dye bandeau and a pop-colour mini bag.",
    base_price: 2_800,
    image: "/images/products/navy-wide-leg-pants-bandeau.jpg",
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 7,
    status: "active",
    size_advice:
      "High-waisted structured fit — runs true to size. These do not have stretch, so measure your natural waist carefully. The front pleats add ease around the hips. Belt included and adjustable.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "wide-leg-pants",
    colors: [{"Navy", "#1B2A6B"}, {"Black", "#1A1A1A"}]
  },
  %{
    name: "Olive High-Waist Wide-Leg Trousers",
    slug: "olive-wide-leg-trousers",
    description:
      "Tailored olive-green wide-leg trousers with a high waist and front button detail. A clean silhouette that pairs perfectly with a white crop shirt for an elevated smart-casual look.",
    base_price: 2_600,
    image: "/images/products/olive-wide-leg-pants-white-crop.jpg",
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 8,
    status: "active",
    size_advice:
      "Tailored structured waist — no stretch, so measure your waist exactly. Runs true to size. The front button detail sits flat when the correct size is chosen. Size up if you're between sizes.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "wide-leg-pants",
    colors: [{"Olive", "#6B7C4A"}, {"Camel", "#C9A882"}]
  },
  %{
    name: "Light-Wash Wide-Leg Jeans",
    slug: "light-wash-wide-leg-jeans",
    description:
      "Relaxed-fit light-wash wide-leg jeans with a high rise and a clean, minimal finish. A wardrobe staple that grounds structured tops like a navy vest perfectly.",
    base_price: 3_200,
    image: "/images/products/navy-vest-wide-leg-jeans.jpg",
    badge_label: "New",
    badge_color: "green",
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: true,
    position: 9,
    status: "active",
    size_advice:
      "High-rise denim runs slightly small in the waist — size up if you're between sizes. Denim has minimal stretch. Measure your waist and hips. The wide leg gives a relaxed, flattering silhouette on most body types.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "wide-leg-pants",
    colors: [{"Light Wash", "#B8D4E8"}, {"Dark Wash", "#2C4F7C"}]
  },
  %{
    name: "Navy Pinstripe Wide-Leg Trousers",
    slug: "navy-pinstripe-wide-leg-trousers",
    description:
      "Smart navy pinstripe wide-leg trousers from the matching blazer set. Power-dressing with an effortless twist — wear as a set or mix and match.",
    base_price: 3_000,
    image: "/images/products/navy-pinstripe-blazer-set.jpg",
    badge_label: "Featured",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: false,
    position: 10,
    status: "active",
    size_advice:
      "Part of a co-ord set — size up slightly for a tailored blazer-and-trouser look with room to layer. Waistband is structured with no stretch. We recommend ordering both pieces in the same size.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "wide-leg-pants",
    colors: [{"Navy", "#1B2A6B"}]
  },

  # ── Skirts ────────────────────────────────────────────────────────────────
  %{
    name: "Denim Maxi Skirt",
    slug: "denim-maxi-skirt",
    description:
      "Voluminous mid-wash denim maxi skirt with a drawstring elasticated waist and sweeping panelled silhouette. Styled with a knotted graphic tee and a red crossbody for a relaxed street-style vibe.",
    base_price: 3_500,
    image: "/images/products/denim-maxi-skirt-front.jpg",
    badge_label: "Bestseller",
    badge_color: "red",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 11,
    status: "active",
    size_advice:
      "Elasticated drawstring waist means this fits a range of sizes. Runs true to size. Maxi length sits at the ankle — ideal for heights 5'3\" and above. Pair with heels or flats.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "skirts",
    colors: [{"Mid-Wash Denim", "#7BA4C7"}, {"Dark Denim", "#2C4F7C"}]
  },
  %{
    name: "Burgundy Pleated Maxi Skirt",
    slug: "burgundy-pleated-maxi-skirt",
    description:
      "Dramatic floor-length burgundy pleated maxi skirt with a front split for ease of movement. Styled with a white logo shirt tucked behind a wide leather belt and paired with black knee boots and a structured satchel.",
    base_price: 3_800,
    image: "/images/products/burgundy-pleated-maxi-skirt.jpg",
    badge_label: "Featured",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: false,
    position: 12,
    status: "active",
    size_advice:
      "Runs true to size with a structured waistband — measure your waist carefully. Full-length with a front split for ease of movement. Best for heights 5'4\" and above. Size up if unsure.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "skirts",
    colors: [{"Burgundy", "#800020"}, {"Black", "#1A1A1A"}]
  },

  # ── Jumpsuits ─────────────────────────────────────────────────────────────
  %{
    name: "Sage Linen Jumpsuit",
    slug: "sage-linen-jumpsuit",
    description:
      "Effortless sage-green linen jumpsuit with frilled shoulders, an elasticated drawstring waist and wide-leg trousers. A one-piece wonder that looks polished with minimal accessories.",
    base_price: 4_000,
    image: "/images/products/sage-linen-jumpsuit.jpg",
    badge_label: "Featured",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: false,
    position: 13,
    status: "active",
    size_advice:
      "Runs true to size. Drawstring waist is fully adjustable. For petite heights (under 5'3\"), the leg length may be slightly long — easy to hem. Model is 5'6\" wearing size M. Measure bust and waist.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "jumpsuits",
    colors: [{"Sage Green", "#8FAF7E"}, {"Blush", "#F5C4C4"}]
  },

  # ── Tops & Knits ──────────────────────────────────────────────────────────
  %{
    name: "Grey Layered Knit Top",
    slug: "grey-layered-knit-top",
    description:
      "Unique layered knit-over-shirt top in grey — a knitted sweater with button front detail sits over a woven shirt hem, creating a relaxed two-in-one look. Pairs effortlessly with shorts or jeans.",
    base_price: 2_500,
    image: "/images/products/grey-layered-knit-set-front.jpg",
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 14,
    status: "active",
    size_advice:
      "Runs true to size. The layered knit-over-shirt effect is built into the design — no separate styling needed. Measure your bust for the best fit. Relaxed drop-shoulder cut.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "tops-and-knits",
    colors: [{"Grey", "#9CA3AF"}, {"Black", "#1A1A1A"}]
  },
  %{
    name: "Black Layered Knit Top",
    slug: "black-layered-knit-top",
    description:
      "Edgy black version of the layered knit-over-shirt top with contrast button detailing. Styled with a quilted black crossbody bag for a sleek, put-together look.",
    base_price: 2_500,
    image: "/images/products/black-grey-layered-knit-set.jpg",
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 15,
    status: "active",
    size_advice:
      "Runs true to size. Same relaxed drop-shoulder construction as the grey version. Measure your bust for the best fit. The contrast button detailing is fixed — no adjustments needed.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "tops-and-knits",
    colors: [{"Black", "#1A1A1A"}, {"Charcoal", "#374151"}]
  },
  %{
    name: "Navy Structured Vest Top",
    slug: "navy-structured-vest-top",
    description:
      "Sharp navy structured vest top with mixed pearl and black button closures and a split hem. Tailored and modern — great over wide-leg jeans or as part of a smart-casual ensemble.",
    base_price: 2_200,
    image: "/images/products/navy-vest-wide-leg-jeans.jpg",
    badge_label: "New",
    badge_color: "green",
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: true,
    position: 16,
    status: "active",
    size_advice:
      "Structured cut runs slightly small — size up if between sizes. Best worn tucked into high-waisted bottoms. Measure your bust for the button fit. The split hem adds length in the back.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "tops-and-knits",
    colors: [{"Navy", "#1B2A6B"}, {"Black", "#1A1A1A"}]
  },
  %{
    name: "Red Knit Cardigan",
    slug: "red-knit-cardigan",
    description:
      "Classic cropped red knit cardigan with jewelled buttons and a layered white collared shirt underneath. A timeless preppy-chic piece that transitions from casual to smart effortlessly.",
    base_price: 2_800,
    image: "/images/products/red-cardigan-black-wide-leg.jpg",
    badge_label: "Bestseller",
    badge_color: "red",
    is_featured: true,
    is_bestseller: true,
    is_new_arrival: false,
    position: 17,
    status: "active",
    size_advice:
      "Cropped fit runs true to size. Pearl jewelled buttons — measure your bust for the best closure. Pairs best with high-waisted trousers or skirts. Knit fabric has a gentle natural stretch.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "tops-and-knits",
    colors: [{"Red", "#CC2936"}, {"Black", "#1A1A1A"}]
  },
  %{
    name: "Navy Pinstripe Blazer",
    slug: "navy-pinstripe-blazer",
    description:
      "Cropped navy pinstripe co-ord blazer with short sleeves and a relaxed open-front silhouette. Wear as a set with the matching wide-leg trousers or layer over a crop top.",
    base_price: 3_500,
    image: "/images/products/navy-pinstripe-blazer-set.jpg",
    badge_label: "Featured",
    badge_color: "blue",
    is_featured: true,
    is_bestseller: false,
    is_new_arrival: false,
    position: 18,
    status: "active",
    size_advice:
      "Relaxed open-front blazer runs slightly oversized. Size down if you prefer a more fitted look. Great as part of the pinstripe co-ord set or layered solo. Measure your shoulders for the best fit.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "tops-and-knits",
    colors: [{"Navy", "#1B2A6B"}, {"Black", "#1A1A1A"}]
  },
  %{
    name: "White Puff-Sleeve Crop Shirt",
    slug: "white-puff-sleeve-crop-shirt",
    description:
      "Crisp white cropped shirt with voluminous puff sleeves and a gathered elastic hem. Pairs perfectly with high-waisted trousers for a polished yet playful look.",
    base_price: 2_000,
    image: "/images/products/olive-wide-leg-pants-white-crop.jpg",
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 19,
    status: "active",
    size_advice:
      "Runs true to size. Puff sleeves are structured and fixed. Measure your bust — the elastic hem gives flexibility around the waist. Cropped length sits above the high waist for a flattering look.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "tops-and-knits",
    colors: [{"White", "#F5F5F5"}, {"Blush", "#F5C4C4"}]
  },
  %{
    name: "Floral Bandeau Crop Top",
    slug: "floral-bandeau-crop-top",
    description:
      "Delicate black and white floral print bandeau crop top with a single shoulder strap. A versatile summer staple that looks stunning with wide-leg palazzo pants.",
    base_price: 1_500,
    image: "/images/products/black-wide-leg-pants-floral-top.jpg",
    badge_label: nil,
    badge_color: nil,
    is_featured: false,
    is_bestseller: false,
    is_new_arrival: false,
    position: 20,
    status: "active",
    size_advice:
      "Runs true to size with a light stretch. Measure your bust for the best fit. The single adjustable shoulder strap gives flexibility. A versatile summer staple — pairs with anything high-waisted.",
    shipping_returns:
      "Nairobi delivery KES 200–300 (1–2 days). Countrywide KES 400–600 (2–4 days). Same-day available before 12 PM. Exchanges within 48 hours — unworn, tags on. WhatsApp 0796 770 862.",
    collection_slug: "tops-and-knits",
    colors: [{"Black/White", "#1A1A1A"}, {"Beige", "#D4B896"}]
  }
]

sizes = ["XS", "S", "M", "L", "XL"]

inserted_products =
  Enum.map(products, fn attrs ->
    {collection_slug, attrs} = Map.pop(attrs, :collection_slug)
    {colors, attrs} = Map.pop(attrs, :colors)
    collection = get_collection.(collection_slug)
    attrs = Map.put(attrs, :collection_id, collection.id)

    # Give every product a stable SKU, and put roughly every third one on sale
    # with a compare-at price ~25% above the live price.
    position = attrs[:position] || 1

    attrs =
      attrs
      |> Map.put(:sku, "CNB" <> String.pad_leading(to_string(position * 7 + 1000), 5, "0"))
      |> then(fn a ->
        if rem(position, 3) == 1 do
          Map.put(a, :compare_at_price, round(a.base_price * 1.25 / 100) * 100)
        else
          a
        end
      end)

    {:ok, product} =
      %Product{}
      |> Product.changeset(attrs)
      |> Repo.insert()

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

variant_count = length(inserted_products) * length(sizes) * 2

IO.puts(
  "✅  Seeded #{length(inserted_collections)} collections, #{length(inserted_products)} products, ~#{variant_count} variants."
)

# ─── Bundle ───────────────────────────────────────────────────────────────────

{:ok, bundle} =
  %Clicknbuy.Bundles.Bundle{}
  |> Clicknbuy.Bundles.Bundle.changeset(%{
    title: "The ClicknBuy Starter Bundle",
    description:
      "Our curated starter bundle — everything you need to build a versatile, head-turning wardrobe. Includes our bestselling Black Wide-Leg Palazzo Pants, the Burgundy Pleated Maxi Skirt, the Red Knit Cardigan and the Denim Maxi Skirt. Mix, match and own every room.",
    image: "/images/products/black-wide-leg-pants-floral-top.jpg",
    is_active: true
  })
  |> Repo.insert()

bundle_item_slugs = [
  "black-wide-leg-palazzo-pants",
  "burgundy-pleated-maxi-skirt",
  "red-knit-cardigan",
  "denim-maxi-skirt"
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
    name: "Amina W.",
    position: 1,
    image: "/images/people/woman1.jpg",
    body:
      "I ordered the Red & Denim Co-ord Set and I'm obsessed! The quality is incredible — the fabric feels premium and the fit is perfect. Got so many compliments on my first wear. Will definitely be ordering again!",
    rating: 5,
    is_active: true,
    product_slug: "red-denim-coord-set"
  },
  %{
    name: "Cynthia O.",
    position: 2,
    image: "/images/people/woman2.jpg",
    body:
      "The Denim Maxi Skirt is everything I wanted. Beautifully structured, the waist fits perfectly and the length is just right. I styled it with a simple white tee and got so many compliments.",
    rating: 5,
    is_active: true,
    product_slug: "denim-maxi-skirt"
  },
  %{
    name: "Grace M.",
    position: 3,
    image: "/images/people/woman3.jpg",
    body:
      "The Sage Linen Jumpsuit is my new favourite piece. Light, breathable and so flattering. I wore it to a garden party and everyone kept asking where I got it from. ClicknBuy never disappoints!",
    rating: 5,
    is_active: true,
    product_slug: "sage-linen-jumpsuit"
  },
  %{
    name: "Fatuma K.",
    position: 4,
    image: "/images/people/woman4.jpg",
    body:
      "Bought the Black Wide-Leg Palazzo Pants and they are absolutely stunning. The pleating is chef's kiss. Delivery was fast and the packaging was so elegant. This is my go-to shop now.",
    rating: 5,
    is_active: true,
    product_slug: "black-wide-leg-palazzo-pants"
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
      "Step-by-step guide on how to place an order at ClicknBuy — shop online or via WhatsApp.",
    content: """
    ## How to Place Your Order

    Ordering from ClicknBuy is simple and straightforward. Here's how:

    ### Option 1 — Order via WhatsApp (Recommended)

    - Screenshot or share the product you love from our Instagram or website.
    - Send us a message on **WhatsApp: 0796 770 862**.
    - Let us know your **size**, preferred **colour**, and **delivery location**.
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

    - **M-Pesa Till No. 5894819** (ClicknBuy)
    - Bank transfer (available on request)

    ## Need Help?

    If you have any trouble placing an order, don't hesitate to reach out on WhatsApp and we'll assist you immediately.
    """
  },
  %{
    slug: "size-guide",
    title: "Size Guide",
    icon: "📐",
    position: 2,
    meta_description:
      "Find your perfect fit with the ClicknBuy size guide — measurements for tops, bottoms, dresses, and coord sets.",
    content: """
    ## Finding Your Perfect Fit

    All our garments are made with Kenyan bodies in mind. We recommend taking your measurements before ordering.

    ### How to Measure Yourself

    - **Bust** — Measure around the fullest part of your chest, keeping the tape parallel to the floor.
    - **Waist** — Measure around your natural waistline, the narrowest part of your torso.
    - **Hips** — Measure around the fullest part of your hips, about 20 cm below your waist.
    - **Length** — Measure from the top of your shoulder to wherever you'd like the garment to end.

    ### Women's Size Chart

    ### Tops & Dresses

    - **XS** — Bust 80–84 cm | Waist 60–64 cm | Hips 86–90 cm
    - **S** — Bust 84–88 cm | Waist 64–68 cm | Hips 90–94 cm
    - **M** — Bust 88–94 cm | Waist 68–74 cm | Hips 94–100 cm
    - **L** — Bust 94–100 cm | Waist 74–80 cm | Hips 100–106 cm
    - **XL** — Bust 100–106 cm | Waist 80–86 cm | Hips 106–112 cm
    - **XXL** — Bust 106–114 cm | Waist 86–94 cm | Hips 112–120 cm

    ### Coord Sets & Bottoms

    - **S** — Waist 64–68 cm | Hips 90–96 cm
    - **M** — Waist 68–74 cm | Hips 96–102 cm
    - **L** — Waist 74–80 cm | Hips 102–108 cm
    - **XL** — Waist 80–86 cm | Hips 108–114 cm

    ## Not Sure About Your Size?

    Every product page includes specific measurements. You can also **WhatsApp us** with your measurements and we'll recommend the best fit for you.
    """
  },
  %{
    slug: "shipping-delivery",
    title: "Shipping & Delivery",
    icon: "🚚",
    position: 3,
    meta_description:
      "ClicknBuy shipping and delivery information — Nairobi same-day delivery and countrywide shipping across Kenya.",
    content: """
    ## Shipping & Delivery

    We deliver across Kenya! Here's everything you need to know about getting your ClicknBuy order to your door.

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
    - ClicknBuy is not responsible for delays caused by third-party courier services once the parcel is dispatched.
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
      "ClicknBuy returns and exchanges policy — we want you to love every piece.",
    content: """
    ## Returns & Exchanges

    We want you to love every piece from ClicknBuy. If something isn't right, here's what you can do.

    ### Our Policy

    - We accept **exchange requests** within **48 hours** of receiving your order.
    - Items must be **unworn, unwashed, and in original condition** with tags intact.
    - **Sale items** are final sale and cannot be exchanged or returned.

    ### Valid Reasons for Exchange

    - Wrong size sent (our error)
    - Wrong item sent (our error)
    - Item has a manufacturing defect

    ### How to Request an Exchange

    - Contact us on **WhatsApp: 0796 770 862** within 48 hours of delivery.
    - Share your order details and clear photos of the item(s).
    - Our team will review and respond within 24 hours.
    - If approved, we'll arrange collection and dispatch the replacement.

    ### Exchanges — Size or Style

    - If you'd like to exchange for a different size or style (your preference), this is subject to stock availability.
    - The customer is responsible for return delivery costs in this case.
    - Any price difference will be charged or refunded accordingly.

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
