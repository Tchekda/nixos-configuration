-- Plugin configuration loader
-- This file loads all plugin configuration files in order
-- Each installer file configures a specific plugin or set of related plugins

local installer = { 'cmp-installer',
                    'lspConfig-installer',
                    'lspsaga-installer',
                    'telescope-installer',
                    'todoComments-installer',
                    'toggleTerm-installer',
                    'treesitter-installer'}

local function load(plugin)
    dofile(os.getenv('HOME') .. "/.config/nvim/" .. "./lua/" .. plugin .. ".lua")
end

for _,plugin in ipairs(installer) do
    load(plugin)
end
