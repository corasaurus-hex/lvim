local global = require('core.global')
require'lspconfig'.solargraph.setup {
    cmd = {
        global.lsp_path .. "lspinstall/ruby/solargraph/bin/solargraph", "stdio"
    },
    root_dir = require('lspconfig.util').root_pattern("."),
    on_attach = require'lsp.global'.common_on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = true
            })
    }
}
