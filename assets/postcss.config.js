// postcss.config.js
module.exports = {
  plugins: [
    require("postcss-import"),
    require("tailwindcss"),
    require("@tailwindcss/ui"),
    require("postcss-nested"),
    require("autoprefixer"),
  ],
}
