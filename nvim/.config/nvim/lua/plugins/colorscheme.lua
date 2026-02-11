return {
  { "folke/tokyonight.nvim" },
  { "rose-pine/neovim",     name = "rose-pine" },
  { "ntk148v/habamax.nvim", dependencies = { "rktjmp/lush.nvim" } },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "habamax", -- specify the exact theme name
    },
  },
}
