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
        // Violet sampled from the Click & Buy logo
        brand: {
          DEFAULT: "#8A37F1",
          50:  "#F6F0FE",
          100: "#EDE1FD",
          200: "#DCC4FB",
          300: "#C79CF8",
          400: "#AC70F5",
          500: "#8A37F1",
          600: "#7B1CEF",
          700: "#6B16D7",
          800: "#5815AF",
          900: "#49158D",
        },
        // Deep violet — Buy Now, prices, active navigation
        accent: {
          DEFAULT: "#7B1CEF",
          50:  "#F7F0FE",
          100: "#EEE0FD",
          200: "#DEC0FB",
          300: "#C895F8",
          400: "#AA5DF4",
          500: "#8A37F1",
          600: "#7B1CEF",
          700: "#6514CE",
          800: "#5313A7",
          900: "#451386",
        },
        // Purple-black used for headings and product titles
        ink: {
          DEFAULT: "#2D1648",
          50:  "#FBF9FE",
          100: "#F3ECF9",
          200: "#E2D5EC",
          300: "#C7B1D8",
          400: "#A282B8",
          500: "#745B88",
          600: "#594269",
          700: "#443051",
          800: "#2D1648",
          900: "#1C0D2D",
        },
        // Very light indigo-tinted page background
        surface: {
          DEFAULT: "#FBF9FE",
          200: "#F3ECF9",
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
