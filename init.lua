-- Basic config
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.g.mapleader = " "
vim.opt.ruler = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.scrolloff = 12
-- vim.opt.termguicolors = true
-- vim.g.fzf_action = { ['enter'] = 'tab split' }
vim.cmd('set relativenumber')

-- for menu
vim.g.netrw_menu = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 75
vim.g.netrw_browse_split = 4
vim.g.netrw_preview = 1
vim.g.netrw_liststyle = 3
--vim.cmd('set autochdir')

local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Completion
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')

-- TS
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = function() vim.fn['TSUpdate']() end })

-- FZF
Plug('junegunn/fzf.vim')
Plug('junegunn/fzf', {
    ['do'] = function()
        vim.fn['fzf#install']()
    end
})

-- Motion
Plug('ggandor/leap.nvim')
Plug('tpope/vim-surround')
Plug('tpope/vim-fugitive')

-- Themes
Plug('navarasu/onedark.nvim')
Plug 'ellisonleao/gruvbox.nvim'

vim.call('plug#end')


-- Configure plugins
require('leap').set_default_mappings()
require("gruvbox").setup({
  undercurl = false,
  overrides = {},
})
vim.cmd("colorscheme gruvbox")

-- Completion setup
local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    mapping = {
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    },
})

-- Env
vim.env.FZF_DEFAULT_COMMAND = 'rg --files'

-- Complation
vim.keymap.set('n', '<leader>b', ':!make<CR>', { noremap = true })

-- Fuzzy
vim.opt.rtp:append('/opt/local/share/fzf/vim')
vim.keymap.set('n', '<leader>ff', ':FZF<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fg', ':RG<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fl', ':Lines<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fh', ':History<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fb', ':Buffers<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fw', ':Windows<CR>', { noremap = true })

-- Git
vim.keymap.set('n', '<leader>gc', ':Commits<CR>', { noremap = true })
vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { noremap = true })
vim.keymap.set('n', '<leader>gs', ':Git switch ', { noremap = true })
vim.keymap.set('n', '<leader>gg', ':Git status<CR>', { noremap = true })

-- Tabs
vim.keymap.set('n', '<A-h>', ':tabprevious<CR>', { noremap = true })
vim.keymap.set('i', '<A-h>', ':tabprevious<CR>', { noremap = true })
vim.keymap.set('n', '<A-l>', ':tabnext<CR>', { noremap = true })
vim.keymap.set('i', '<A-l', ':tabnext<CR>', { noremap = true })

-- LSP
vim.keymap.set('n', '<c-alt>', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Treesitter
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end
})

-- LSP Setup with vim.lsp.config (modern Neovim 0.11+ approach)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('gopls', {
    cmd = { "gopls" },
    root_markers = { "go.mod" },
    filetypes = { "go" },
    capabilities = capabilities,
})

vim.lsp.config('lua_ls', {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    capabilities = capabilities,
})

vim.lsp.config('ocaml', {
    cmd = { "ocamllsp" },
    filetypes = { "ocaml" },
    capabilities = capabilities,
})

vim.lsp.config('clangd', {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    capabilities = capabilities,
})

vim.lsp.config('zls', {
    cmd = { "zls" },
    root_markers = { "zls.json", "build.zig", ".git" },
    filetypes = { "zig", "zir" },
    capabilities = capabilities,
})

-- SourceKit-LSP with special configuration for Swift completion
vim.lsp.config('sourcekit', {
    cmd = { "sourcekit-lsp" },
    filetypes = { "swift" },
    root_markers = { "Package.swift", "buildServer.json", ".git" },
    capabilities = vim.tbl_deep_extend('force', capabilities, {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    }),
})

vim.lsp.enable('lua_ls')
-- vim.lsp.enable('gopls')
vim.lsp.enable('ocaml')
-- vim.lsp.enable('clangd')
-- vim.lsp.enable('zls')
vim.lsp.enable('sourcekit')
