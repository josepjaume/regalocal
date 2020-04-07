module.exports = {
  // https://stylelint.io/user-guide/configuration
  extends: [
    "stylelint-config-standard",
    "stylelint-config-rational-order",
    "stylelint-prettier/recommended",
  ],
  plugins: ["stylelint-prettier"],
  rules: {
    "prettier/prettier": true,
    "at-rule-no-unknown": null,
  },
}
