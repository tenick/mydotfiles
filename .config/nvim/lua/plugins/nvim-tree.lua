return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional but recommended
        lazy = false,
        keys = {
            { "<C-t>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Tree" },
        },
        opts = {
            view = {
                side = "right",
            },
            filters = {
                dotfiles = false,
            },
            renderer = {
                group_empty = true,
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return {
                        desc = "nvim-tree: " .. desc,
                        buffer = bufnr,
                        noremap = true,
                        silent = true,
                        nowait = true,
                    }
                end

                -- Default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- Custom mappings inside nvim-tree buffer
                vim.keymap.set("n", "<C-t>", api.tree.toggle, opts("Toggle Tree"))
                vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
            end,
        },
    },
}
