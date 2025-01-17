-- Install Lsp server
-- :LspInstall sumneko_lua

-- Install debugger
-- :DIInstall lua

local global = require("core.global")
local languages_setup = require("languages.base.utils")
local nvim_lsp_util = require("lspconfig/util")
local default_debouce_time = 150
local dap_install = require("dap-install")
local dap = require("dap")

local language_configs = {}

language_configs["lsp"] = function()
    local server_setup = {
        flags = {
            debounce_text_changes = default_debouce_time,
        },
        autostart = true,
        filetypes = { "lua" },
        on_attach = function(client, bufnr)
            table.insert(global["languages"]["lua"]["pid"], client.rpc.pid)
            vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            languages_setup.document_highlight(client, bufnr)
            languages_setup.document_formatting(client, bufnr)
        end,
        capabilities = languages_setup.get_capabilities(),
        settings = {
            Lua = {
                completion = { keywordSnippet = "Disable" },
                diagnostics = {
                    globals = { "vim", "use", "packer_plugins" },
                    disable = { "lowercase-global" },
                },
                runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    },
                },
            },
        },
        root_dir = function(fname)
            return nvim_lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
    }
    languages_setup.setup_lsp("sumneko_lua", server_setup)
end

language_configs["dap"] = function()
    dap_install.config("lua", {})
    dap.configurations.lua = {
        {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
            host = function()
                local value = vim.fn.input("Host [127.0.0.1]: ")
                if value ~= "" then
                    return value
                end
                return "127.0.0.1"
            end,
            port = function()
                local val = tonumber(vim.fn.input("Port: "))
                assert(val, "Please provide a port number")
                return val
            end,
        },
    }
end

return language_configs
