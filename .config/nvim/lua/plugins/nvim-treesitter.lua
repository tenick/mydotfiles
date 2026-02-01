return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "c", "lua", "vim", "vimdoc", "query",
          "markdown", "cpp", "python", "latex"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
