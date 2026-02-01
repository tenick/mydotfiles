return {
    {
        "mfussenegger/nvim-dap",
        opts = {
            adapters = {
                lldb = {
                    type = "server",
                    port = "${port}",
                    executable = {
                        command = "codelldb",
                        args = { "--port", "${port}" },
                        detached = vim.loop.os_uname().sysname ~= "Windows",
                    },
                },
            },
            configurations = {
                cpp = {
                    {
                        name = "Launch de DEBUG konfeeg",
                        type = "lldb",
                        request = "launch",
                        program = function()
                            local cwd = string.format("%s%s", vim.fn.getcwd(), "/")
                            return vim.fn.input("Path to executable: ", cwd, "file")
                        end,
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                    },
                },
                c = {},
                rust = {}
            },
        },
        config = function(_, opts)
            local dap = require("dap")
            -- Load adapters
            for name, adapter in pairs(opts.adapters) do
                dap.adapters[name] = adapter
            end
            -- Load configurations
            for lang, configs in pairs(opts.configurations) do
                if vim.tbl_isempty(configs) and opts.configurations["cpp"] then
                    dap.configurations[lang] = opts.configurations["cpp"]
                else
                    dap.configurations[lang] = configs
                end
            end

            -- Optional keymaps
            local keymap = vim.api.nvim_set_keymap
            keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", {noremap=true, silent=true})
            keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", {noremap=true, silent=true})
            keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", {noremap=true, silent=true})
            keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", {noremap=true, silent=true})
            keymap("n", "<Leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", {noremap=true, silent=true})
            keymap("n", "<Leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", {noremap=true, silent=true})
            keymap("n", "<Leader>dr", ":lua require'dap'.repl.open()<CR>", {noremap=true, silent=true})
        end,
    },
}

