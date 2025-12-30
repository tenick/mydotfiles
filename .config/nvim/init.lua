-- lazy
require("config.lazy")

-- BASIC SETTINGS
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Encoding
vim.opt.encoding = "utf-8"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Searching
vim.opt.hlsearch = true         -- highlight search
vim.opt.incsearch = true        -- incremental search
vim.opt.ignorecase = true       -- case insensitive unless capital

-- UI
vim.opt.ruler = true            -- show cursor position
vim.opt.laststatus = 2          -- always show status line
vim.opt.wrap = false            -- no line wrapping
vim.opt.termguicolors = true    -- better colors
vim.opt.signcolumn = "yes"      -- always show gutter signs

-- Tabs
vim.opt.shiftround = true       -- round indent to nearest tabstop

-- colorscheme
vim.cmd.colorscheme("blackhole")

-- terminal mappings
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

-- transparent bg for a color scheme (must come after setting the colorscheme)
local transparent_groups = {
  "Normal", "NormalNC", "EndOfBuffer",
  "SignColumn", "VertSplit", "StatusLine", "TabLineFill"
}

for _, group in ipairs(transparent_groups) do
  vim.api.nvim_set_hl(0, group, { bg = "none" })
end


-- clipboard
vim.api.nvim_set_keymap("i", "<C-a>", '<ESC>ggVG', { noremap = true })
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', { noremap = true })

-- lspconfig stuffs
vim.lsp.enable('lua_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('jdtls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('cssls')
vim.lsp.enable('html')
vim.lsp.enable('pylsp')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('qmlls', {
    capabilities = capabilities,
    cmd = {"qmlls", "-E"}
})

-- enable folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


-- NvimTree config
vim.cmd [[
  hi NvimTreeNormal guibg=NONE ctermbg=NONE
  hi NvimTreeNormalNC guibg=NONE ctermbg=NONE
  hi NvimTreeEndOfBuffer guibg=NONE ctermbg=NONE
  hi NvimTreeVertSplit guibg=NONE ctermbg=NONE
]]

