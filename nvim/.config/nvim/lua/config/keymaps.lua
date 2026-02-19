-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete previous word", noremap = true, silent = true })
vim.keymap.set(
  "i",
  "<C-H>",
  "<C-w>",
  { desc = "Delete previous word (terminal fallback)", noremap = true, silent = true }
)
