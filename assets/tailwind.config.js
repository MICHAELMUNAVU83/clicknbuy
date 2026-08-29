// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/clicknbuy_web.ex",
    "../lib/clicknbuy_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        // Structural indigo — headers, hero panels, "On Sale" badges, links
        brand: {
          DEFAULT: "#2F32CE",
          50:  "#f0f1ff",
          100: "#e0e2ff",
          200: "#c4c7ff",
          300: "#9fa3fb",
          400: "#7a7ef4",
          500: "#4d51e0",
          600: "#2F32CE",
          700: "#2427A5",
          800: "#1c1f80",
          900: "#141659",
        },
        // Call-to-action red — Buy Now, prices, active nav
        accent: {
          DEFAULT: "#DB4A44",
          50:  "#fef3f2",
          100: "#fde3e1",
          200: "#facbc8",
          300: "#f4a8a3",
          400: "#e9756f",
          500: "#DB4A44",
          600: "#C13A35",
          700: "#a12e2a",
          800: "#7f2523",
          900: "#5c1b19",
        },
        // Navy used for headings and product titles
        ink: {
          DEFAULT: "#122554",
          50:  "#f5f7ff",
          100: "#e8ecf8",
          200: "#ccd5e9",
          300: "#a3b2d1",
          400: "#7286ae",
          500: "#4a5f8b",
          600: "#2c4272",
          700: "#1d3162",
          800: "#122554",
          900: "#0b1838",
        },
      },
      fontFamily: {
        script:  ["Dancing Script", "cursive"],
        serif:   ["Playfair Display", "Georgia", "serif"],
        sans:    ["DM Sans", "ui-sans-serif", "system-ui", "sans-serif"],
        display: ["Poppins", "ui-sans-serif", "system-ui", "sans-serif"],
        ui:      ["Inter", "ui-sans-serif", "system-ui", "sans-serif"],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ]
}
