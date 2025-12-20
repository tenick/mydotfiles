return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "SirVer/ultisnips",
            "quangnguyen30192/cmp-nvim-ultisnips"
        },
        config = function()
            local cmp = require("cmp")
            local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["UltiSnips#Anon"](args.body)
                    end,
                },
                sources = cmp.config.sources({
                        { name = "ultisnips" },
                        { name = "nvim_lsp" },
                    }, {
                        { name = "buffer" },
                    }
                ),
                mapping = cmp.mapping.preset.insert({ 
                    ["<C-Space>"] = cmp.mapping.complete(), 
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Tab to select next item
                    ["<Tab>"] = cmp.mapping(function(fallback) 
                        if cmp.visible() then 
                            cmp.select_next_item() 
                        else 
                            fallback() 
                        end 
                    end, { "i", "s" }), 

                    -- Shift-Tab to select previous item
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then 
                            cmp.select_prev_item() 
                        else 
                            fallback() 
                        end 
                    end, { "i", "s" }), 
                }),
            })

            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
