-- LSP (Language Server Protocol) configuration
-- Provides IDE-like features: autocomplete, diagnostics, go-to-definition, etc.
--
-- Configured language servers:

-- Common LSP keybindings (configured elsewhere or default):
--   gd          - Go to definition
--   gD          - Go to declaration
--   gr          - Go to references
--   gi          - Go to implementation
--   K           - Hover documentation
--   <C-k>       - Signature help
--   <leader>rn  - Rename symbol
--   <leader>ca  - Code action
--   <leader>f   - Format document
--   [d / ]d     - Navigate diagnostics
--
-- Mason provides a UI to install/update language servers
-- Usage: :Mason to open the installer

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
local servers = {  }
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
end

for _, lsp in pairs(servers) do
    vim.lsp.config[lsp] = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

require("mason-lspconfig").setup {
   ensure_installed = servers,
}

